title = 'ownTech'

def main(ctx):
  return [
    docker(ctx, 'amd64'),
    docker(ctx, 'arm64v8'),

    manifest(ctx),
    readme(ctx),
    badges(ctx),

    client(ctx),

    changelog(ctx),
    website(ctx),
  ]

def docker(ctx, arch):
  if arch == "amd64":
    agent = "amd64"

  if arch == "arm32v6":
    agent = "arm"

  if arch == "arm32v7":
    agent = "arm"

  if arch == "arm64v8":
    agent = "arm64"

  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': arch,
    'platform': {
      'os': 'linux',
      'arch': agent,
    },
    'steps': [
      {
        'name': 'dryrun',
        'image': 'plugins/docker:latest',
        'pull': 'always',
        'settings': {
          'dry_run': True,
          'tags': arch,
          'repo': ctx.repo.slug,
          'dockerfile': 'docker/Dockerfile.%s' % (arch),
        },
        'when': {
          'ref': {
            'include': [
              'refs/pull/**',
            ],
          },
        },
      },
      {
        'name': 'docker',
        'image': 'plugins/docker:latest',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'docker_username',
          },
          'password': {
            'from_secret': 'docker_password',
          },
          'auto_tag': True,
          'auto_tag_suffix': arch,
          'repo': ctx.repo.slug,
          'dockerfile': 'docker/Dockerfile.%s' % (arch),
        },
        'when': {
          'ref': {
            'exclude': [
              'refs/pull/**',
            ],
          },
        },
      },
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
        'refs/pull/**',
      ],
    },
  }

def manifest(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'manifest',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'execute',
        'image': 'plugins/manifest:latest',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'docker_username',
          },
          'password': {
            'from_secret': 'docker_password',
          },
          'spec': 'docker/manifest.tmpl',
          'auto_tag': True,
          'ignore_missing': True,
        },
      },
    ],
    'depends_on': [
      'amd64',
      'arm64v8',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  }

def readme(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'readme',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'execute',
        'image': 'sheogorath/readme-to-dockerhub:latest',
        'pull': 'always',
        'environment': {
          'DOCKERHUB_USERNAME': {
            'from_secret': 'docker_username',
          },
          'DOCKERHUB_PASSWORD': {
            'from_secret': 'docker_password',
          },
          'DOCKERHUB_REPO_PREFIX': ctx.repo.namespace,
          'DOCKERHUB_REPO_NAME': ctx.repo.name,
          'SHORT_DESCRIPTION': 'Docker images for %s' % (title),
          'README_PATH': 'README.md',
        },
      },
    ],
    'depends_on': [
      'amd64',
      'arm64v8',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  }

def badges(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'badges',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'execute',
        'image': 'plugins/webhook:latest',
        'pull': 'always',
        'settings': {
          'urls': {
            'from_secret': 'microbadger_url',
          },
        },
      },
    ],
    'depends_on': [
      'amd64',
      'arm64v8',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  }

def client(ctx):
  if ctx.build.event == "tag":
    settings = {
      'endpoint': {
        'from_secret': 's3_endpoint',
      },
      'access_key': {
        'from_secret': 'aws_access_key_id',
      },
      'secret_key': {
        'from_secret': 'aws_secret_access_key',
      },
      'bucket': {
        'from_secret': 's3_bucket',
      },
      'path_style': True,
      'strip_prefix': 'dist/',
      'source': 'dist/*',
      'target': '/minecraft/%s/%s' % (ctx.repo.name, ctx.build.ref.replace("refs/tags/v", "")),
    }
  else:
    settings = {
      'endpoint': {
        'from_secret': 's3_endpoint',
      },
      'access_key': {
        'from_secret': 'aws_access_key_id',
      },
      'secret_key': {
        'from_secret': 'aws_secret_access_key',
      },
      'bucket': {
        'from_secret': 's3_bucket',
      },
      'path_style': True,
      'strip_prefix': 'dist/',
      'source': 'dist/*',
      'target': '/minecraft/%s/testing' % (ctx.repo.name),
    }

  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'client',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'package',
        'image': 'toolhippie/archiver:latest',
        'pull': 'always',
        'commands': [
          'make package',
        ],
      },
      {
        'name': 'gpgsign',
        'image': 'plugins/gpgsign:latest',
        'pull': 'always',
        'settings': {
          'key': {
            'from_secret': 'gpgsign_key',
          },
          'passphrase': {
            'from_secret': 'gpgsign_passphrase',
          },
          'files': [
            'dist/*.zip',
          ],
          'detach_sign': True,
        },
      },
      {
        'name': 'upload',
        'image': 'plugins/s3:latest',
        'pull': 'always',
        'settings': settings,
        'when': {
          'ref': [
            'refs/heads/master',
            'refs/tags/**',
          ],
        },
      },
      {
        'name': 'changelog',
        'image': 'toolhippie/calens:latest',
        'pull': 'always',
        'commands': [
          'calens --version %s -o dist/CHANGELOG.md' % ctx.build.ref.replace("refs/tags/v", "").split("-")[0],
        ],
        'when': {
          'ref': [
            'refs/tags/**',
          ],
        },
      },
      # {
      #   'name': 'curse',
      #   'image': 'plugins/curseforge:latest',
      #   'pull': 'always',
      #   'settings': {
      #     'api_key': {
      #       'from_secret': 'curse_token',
      #     },
      #     'project': ctx.repo.name,
      #     'file': 'dist/%s-%s.zip' % (title, ctx.build.ref.replace("refs/tags/v", "")),
      #     'title': '%s %s' % (title, ctx.build.ref.replace("refs/tags/", "")),
      #     'note': 'dist/CHANGELOG.md',
      #     'games': [
      #       6756,
      #     ],
      #   },
      #   'when': {
      #     'ref': [
      #       'refs/tags/**',
      #     ],
      #   },
      # },
      {
        'name': 'github',
        'image': 'plugins/github-release:latest',
        'pull': 'always',
        'settings': {
          'api_key': {
            'from_secret': 'github_token',
          },
          'files': [
            'dist/*.zip',
            'dist/*.sha256',
            'dist/*.asc',
          ],
          'title': ctx.build.ref.replace("refs/tags/", ""),
          'note': 'dist/CHANGELOG.md',
        },
        'when': {
          'ref': [
            'refs/tags/**',
          ],
        },
      },
    ],
    'depends_on': [
      'manifest',
      'readme',
      'badges',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  }

def changelog(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'changelog',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'clone': {
      'disable': True,
    },
    'steps': [
      {
        'name': 'clone',
        'image': 'plugins/git-action:latest',
        'pull': 'always',
        'settings': {
          'actions': [
            'clone',
          ],
          'remote': 'https://github.com/%s' % (ctx.repo.slug),
          'branch': ctx.build.source if ctx.build.event == 'pull_request' else 'master',
          'path': '/drone/src',
          'netrc_machine': 'github.com',
          'netrc_username': {
            'from_secret': 'github_username',
          },
          'netrc_password': {
            'from_secret': 'github_token',
          },
        },
      },
      {
        'name': 'generate',
        'image': 'toolhippie/calens:latest',
        'pull': 'always',
        'commands': [
          'make changelog',
        ],
      },
      {
        'name': 'output',
        'image': 'toolhippie/calens:latest',
        'pull': 'always',
        'commands': [
          'cat CHANGELOG.md',
        ],
      },
      {
        'name': 'publish',
        'image': 'plugins/git-action:latest',
        'pull': 'always',
        'settings': {
          'actions': [
            'commit',
            'push',
          ],
          'message': 'Automated changelog update [skip ci]',
          'branch': 'master',
          'author_email': 'github@webhippie.de',
          'author_name': 'Webhippie',
          'netrc_machine': 'github.com',
          'netrc_username': {
            'from_secret': 'github_username',
          },
          'netrc_password': {
            'from_secret': 'github_token',
          },
        },
        'when': {
          'ref': {
            'exclude': [
              'refs/pull/**',
            ],
          },
        },
      },
    ],
    'depends_on': [
      'client',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/pull/**',
      ],
    },
  }

def website(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'website',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'generate',
        'image': 'webhippie/hugo:latest',
        'pull': 'always',
        'commands': [
          'make docs',
        ],
      },
      {
        'name': 'publish',
        'image': 'plugins/gh-pages:latest',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'github_username',
          },
          'password': {
            'from_secret': 'github_token',
          },
          'pages_directory': 'docs/public/',
          'temporary_base': 'tmp/',
        },
        'when': {
          'ref': {
            'exclude': [
              'refs/pull/**',
            ],
          },
        },
      },
    ],
    'depends_on': [
      'changelog',
    ],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/pull/**',
      ],
    },
  }
