# ruby-annocheck-test

This repository is to check [Ruby](https://github.com/ruby/ruby) by [annocheck](https://sourceware.org/annobin/).

## My environment

* Fedora 36
* GCC: gcc-12.1.1-1.fc36.x86_64
  ```
  $ rpm -q gcc
  gcc-12.1.1-1.fc36.x86_64
  ```
* Other RPM packages reuqired to build Ruby.
  ```
  $ sudo dnf install autoconf libffi-devel openssl-devel libyaml-devel readline-devel procps multilib-rpm-config gcc make zlib-devel bison ruby

  $ rpm -q autoconf libffi-devel openssl-devel libyaml-devel readline-devel procps multilib-rpm-config gcc make zlib-devel bison ruby
  autoconf-2.71-2.fc36.noarch
  libffi-devel-3.4.2-8.fc36.x86_64
  openssl-devel-3.0.2-5.fc36.x86_64
  libyaml-devel-0.2.5-7.fc36.x86_64
  readline-devel-8.1-6.fc36.x86_64
  package procps is not installed
  multilib-rpm-config-1-19.fc36.noarch
  gcc-12.1.1-1.fc36.x86_64
  make-4.3-7.fc36.x86_64
  zlib-devel-1.2.11-31.fc36.x86_64
  bison-3.8.2-2.fc36.x86_64
  ruby-3.1.2-164.fc36.x86_64
  ```

## Test by annocheck

Use the `annocheck` below.

```
$ rpm -qf /bin/annocheck
annobin-annocheck-10.73-1.fc36.x86_64
```

There are 2 `ruby` binnary files.

```
$ tree binaries/
binaries/
└── 20220617-commit-78425d7e74
    ├── build_with_fedora_build_flags
    │   └── ruby
    └── build_with_minimal_flags
        └── ruby
```

The binary `binaries/20220617-commit-78425d7e74/build_with_fedora_build_flags/ruby` was built with Fedora Ruby's build flags with `build_with_fedora_build_flags.sh`.

```
$ annocheck binaries/20220617-commit-78425d7e74/build_with_fedora_build_flags/ruby
annocheck: Version 10.73.
Hardened: ruby: PASS.
```

The binary  `binaries/20220617-commit-78425d7e74/build_with_minimal_flags/ruby` was built with minimal build flags with `build_with_minimal_flags.sh`.

```
$ annocheck binaries/20220617-commit-78425d7e74/build_with_minimal_flags/ruby
annocheck: Version 10.73.
Hardened: ruby: MAYB: test: notes because not all of the .text section is covered by notes 
Hardened: ruby: FAIL: pie test because not built with '-Wl,-pie' 
Hardened: Rerun annocheck with --verbose to see more information on the tests.
Hardened: ruby: Overall: FAIL.
```

Here are documents printed by `annocheck --verbose [binary]`.

* https://sourceware.org/annobin/annobin.html/Test-notes.html
* https://sourceware.org/annobin/annobin.html/Test-pie.html

## How did I prepared the binaries

Download this repository as follows.

```
$ cd ~/git
$ git clone https://github.com/junaruga/ruby-annocheck-test.git
```

Download Ruby somewhere as follows.

```
$ cd ~/git
$ git clone https://github.com/ruby/ruby.git
$ cd ruby
$ git checkout 78425d7e74887b57ee15e6b8933bd3878db6a888
```

Build Ruby with build flags used in Fedora Ruby on the ruby directory above.

```
$ pwd
/home/jaruga/git/ruby

$ git clean -fdx

$ ~/git/ruby-annocheck-test/build_with_fedora_build_flags.sh

$ ls ruby
ruby*

$ cp -p ruby ~/git/ruby-annocheck-test/binaries/20220617-commit-78425d7e74/build_with_fedora_build_flags/
```

Build Ruby with minimal flags to pass annocheck as much as possible.

```
$ pwd
/home/jaruga/git/ruby

$ git clean -fdx

$ ~/git/ruby-annocheck-test/build_with_minimal_flags.sh

$ ls ruby
ruby*

$ cp -p ruby ~/git/ruby-annocheck-test/binaries/20220617-commit-78425d7e74/build_with_minimal_flags/
```

## GCC specs files

In the `build_with_fedora_build_flags.sh`, the `gcc -specs=file` options are used. I copied the specs files to `gcc_specs/`. The files are managed in the [redhat-rpm-config](https://src.fedoraproject.org/rpms/redhat-rpm-config/tree/rawhide) RPM package. I tested with the files in the `redhat-rpm-config` RPM version below.

```
$ rpm -q redhat-rpm-config
redhat-rpm-config-220-1.fc36.noarch
```
