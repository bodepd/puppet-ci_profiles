class ci_profiles::jenkins::plugins {

  jenkins::plugin { 'jobConfigHistory':
    version => '2.8',
  }

  jenkins::plugin { 'git':
    version => '2.2.2',
  }

  # github specific plugins
  jenkins::plugin { 'github':
    version => '1.9.1',
  }
  jenkins::plugin { 'github-api':
    version => '1.55',
  }
  jenkins::plugin { 'github-oauth':
    version => '0.19',
  }

  jenkins::plugin { 'publish-over-ssh':
    version => '1.7',
  }

  jenkins::plugin { 'rebuild':
    version => '1.21',
  }
  jenkins::plugin { 'timestamper':
    version => '1.5.12',
  }

  jenkins::plugin { 'gearman-plugin':
    version => '0.0.3',
  }

  jenkins::plugin { 'ansicolor':
    version => '0.3.1',
  }
}
