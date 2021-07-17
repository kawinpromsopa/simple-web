## Table of Contents

* [Repository Secret](#repository-secret)
    * [Add or update repository secret](#add-or-update-repository-secret)
* [Docker ENV](#docker-env)
    * [Add or update docker env into github workflows](#add-or-update-docker-env-into-github-workflows)
    


### 1). Add and Update Repository Secret

#### Add new
- 1). On repository `[Settings]` => `Secrets` => `New repository secret`
```
Name: $ENV_DOCKER_ENV_SIMPLE_KEY
Value: SIMPLE_KEY=simple-value
```

```
eg:
Name: DEV_DOCKER_ENV_NEXT_PUBLIC_S3_HOST
Value: NEXT_PUBLIC_S3_HOST=s3://simple-url
```

#### Update
- 1). On repository `[Settings]` => `Secrets` => Choose exist repository secrets => Update => Type new value

**NOTE: Github can't change the `KEY` of secret name, If you want to change just delete and add new.


### 2). Add or update docker env into github workflows

#### Add/update file `.github/workflows/$env.yml` into `step: Deploy application on $ENV environment` **Line 59**
```
##
## PIPELNES DOCKER ENV
##
DOCKER_ENV_SIMPLE_KEY_1: ${{ secrets.DEV_DOCKER_ENV_SIMPLE_KEY_1 }}

##
## PASS DOCKER ENV
##
DOCKER_ENV_SIMPLE_KEY_1=${{ env.DOCKER_ENV_SIMPLE_KEY_1 }}
echo $DOCKER_ENV_SIMPLE_KEY_1 >> .env
```

ref: https://github.com/kawinpromsopa/simple-web/blob/develop/.github/workflows/develop.yml
