# ECS problem event rules

Cloudformation template to create Cloudwatch event rules that are triggered by
ECS Service warnings+failures and ECS Task essential container failures. These
rules will send SNS topic notifications about these problems.


## Setup

* Bash on Linux-based OS
* [AWS cli 1](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)

## Usage

```sh
build.sh [--deploy arn:aws:sns:...] [--down]
```

For example

```sh
build.sh --deploy arn:aws:sns:us-east-1:123456789012:mysnstopic
```

## Notes

You can use the YAML template directly with your own command line tools and the AWS web console. It is not necessary to use `build.sh`.
