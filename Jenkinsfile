#!groovy
/*
# Copyright 2017 Juniper Networks, Inc. All rights reserved.
# Licensed under the Juniper Networks Script Software License (the "License").
# You may not use this script file except in compliance with the License, which is located at
# http://www.juniper.net/support/legal/scriptlicense/
# Unless required by applicable law or otherwise agreed to in writing by the parties,
# software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied.
*/
@Library('PS-Shared-libs') _

node('docker') {
    def version
    
    stage('Checkout'){
        checkout scm
    }
    stage('Build image'){
        // Get the current version of container
        version = sh(returnStdout: true, script: 'make version').trim()
        commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        // Get information from the container
        def pythonVersion = sh(returnStdout: true, script: 'make python-version').trim()
        def alpineVersion = sh(returnStdout: true, script: 'make alpine-version').trim()
        def ansibleVersion = sh(returnStdout: true, script: 'make ansible-version').trim()
        def junosEzncVersion = sh(returnStdout: true, script: 'make junos-eznc-version').trim()
        def jsnapyVersion = sh(returnStdout: true, script: 'make jsnapy-version').trim()
        // Get current date
        def now = new Date()
        // Build the image with label metadata
        dockerImage action: 'build', 
                    imageTag: version,
                    buildArgs: " --label net.juniper.image.release=${version}" +
                                " --label net.juniper.image.branch=" + "${env.SOURCE_BRANCH}".replaceAll('refs/heads/','') +
                                " --label net.juniper.image.commit=${commit}" +
                                " --label net.juniper.image.issue.date=" + now.format("yyyy-MM-dd", TimeZone.getTimeZone('UTC')) +
                                " --label net.juniper.image.create.date=" + now.format("yyyy-MM-dd", TimeZone.getTimeZone('UTC')) +
                                ' --label net.juniper.image.mantainer="Juniper Networks, Inc."' +
                                " --label net.juniper.image.python-version=${pythonVersion}" +
                                " --label net.juniper.image.alpine-version=${alpineVersion}" +
                                " --label net.juniper.image.ansible-version=${ansibleVersion}" +
                                " --label net.juniper.image.junos-eznc-version=${junosEzncVersion}" +
                                " --label net.juniper.image.jsnapy-version=${jsnapyVersion}" +
                                ' . '
    }

    stage('Test image'){
        // Validate the image
        sh 'make docker-test'
    }

    stage('Push image'){
        dockerImage action: 'push'
    }

    stage('Push to Docker Hub'){
        // Not actually rebuilding, due to cache. Using for the purpose of retagging.
        dockerImage action: 'build', tag: 'juniperps/pytest'
        // Using ssteiner's DockerHub credentials (ntwrkguru)
        dockerImage action: 'push', imageTag: version, url: '', credentials: '1a7b4d9f-8b15-4d93-beb9-8d34f010f543'
    }
}