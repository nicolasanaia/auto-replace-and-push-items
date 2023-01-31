import os
import csv
import json
import time
import requests

REGION = 'us-east-2'
PROFILE = ''
directory = ''
env = ''
feature = ''
title = ''
user_email = ''
user_name = ''

AWS_BASE_COMMAND = f'aws --profile {PROFILE} --region {REGION}'


def get_repos_names():
    list = os.listdir(directory)
    print(list)
    return list


def create_prs():
    repo_errors = []
    prs = []

    list = get_repos_names()
    for repo in list:
        print(repo)
        try:
            command = f'{AWS_BASE_COMMAND} codecommit create-pull-request --title "{feature.upper()}: {title}" --description "{feature.upper()}" --targets repositoryName={repo},sourceReference=feature/{feature}-{env},destinationReference={env}'
            result = json.loads(os.popen(command).read())
            pr_id = result['pullRequest']['pullRequestId']
            revision_id = result['pullRequest']['revisionId']
            source_commit = result['pullRequest']['pullRequestTargets'][0]['sourceCommit']
            prs.append([f'https://{REGION}.console.aws.amazon.com/codesuite/codecommit/repositories/{repo}/pull-requests/{pr_id}/details?region={REGION}',
                       pr_id, revision_id, source_commit, repo])
        except:
            repo_errors.append(repo)
            pass
    with open(f'./report_prs.csv', 'w', encoding='utf8') as f:
        h_line = 'url,pr_id,revision_id,source_commit,repository'
        f.write(f'{h_line}\n')
        for line in prs:
            f.write(f'{line[0]},{line[1]},{line[2]},{line[3]},{line[4]}\n')
        f.close()
    with open(f'./report_prs_organized.csv', 'w', encoding='utf8') as f:
        h_line = 'url'
        f.write(f'{h_line}\n')
        for line in prs:
            f.write(f'{line[4]}\n{line[0]}\n\n')
        f.close()
    print(repo_errors)


def check_prs_to_merge(prs_to_merge):
    not_approved = True
    while not_approved:
        time.sleep(10)
        for pr in prs_to_merge:
            get_approval_command = f'{AWS_BASE_COMMAND} codecommit evaluate-pull-request-approval-rules --region {REGION} --pull-request-id {pr[1]} --revision-id {pr[2]}'
            approval = json.loads(os.popen(get_approval_command).read())
            print(approval)
            if approval['evaluation']['approved'] or approval['evaluation']['overridden']:
                os.system(
                    f'{AWS_BASE_COMMAND} codecommit merge-pull-request-by-three-way --region {REGION} --pull-request-id {pr[1]} --repository-name {pr[4]} --author {user_email} name {user_name} --email u --commit-message "{feature.upper()}: {title}"')
                prs_to_merge = [x for x in prs_to_merge if x[0] != pr[0]]
            if len(prs_to_merge) == 0:
                not_approved = False


# get_repos_names()
create_prs()
# check_prs_to_merge(rows)
