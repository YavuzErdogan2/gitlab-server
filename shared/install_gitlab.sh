#!/bin/bash
sudo dnf install -y git
git remote remove origin 2>/dev/null || true


git config --global user.email "yavuz.erdogan@student.hogent.be"
git config --global user.name "Yavuz Erdogan"

# Maak een lokale Git repository en voeg demo-applicatie bestanden toe
cd /vagrant/shared || exit 1
if [ ! -d .git ]; then
    git init
fi
# Voeg de demo-applicatie bestanden toe
git add static templates sample_app.py sample-app.sh

# Voeg een .gitlab-ci.yml bestand toe
if [ ! -f .gitlab-ci.yml ]; then
    echo -e "stages:\n  - build\n  - test\n  - deploy\n\nbuild_job:\n  stage: build\n  script:\n    - echo 'Building the application'\n    - ./sample-app.sh\n\ntest_job:\n  stage: test\n  script:\n    - echo 'Testing the application'\n    - ./sample-app.sh\n\ndeploy_job:\n  stage: deploy\n  script:\n    - echo 'Deploying the application'\n    - ./sample-app.sh" > .gitlab-ci.yml
    git add .gitlab-ci.yml
fi
# Commit de bestanden
git commit -m "Initial commit" || echo "Nothing to commit, working tree clean"

# Verbind met de remote repository en push
REMOTE_URL="http://$(hostname -I | awk '{print $1}')/root/demo-app.git"

git remote add origin $REMOTE_URL
git push -u origin master
