# TERRAFORM + AZURE PIPELINES PROJECT

## Effectively automated the build process for my Terraform infrastructure while providing insights into code quality and security through the integration of SonarCloud SAST scanning.

## Terraform Configuration:

![image](https://github.com/CloudHirsi/TFproject/assets/153539293/f4abd146-0365-48ab-aae0-f7dfd171a9af)


## YAML Code for Build pipeline:

``` YAML
trigger: 
- main

stages:
- stage: Build
  jobs:
  - job: Build
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'

    - task: SonarCloudPrepare@1
      inputs:
       SonarCloud: 'SonarCloud'
       organization: 'hhsonarcloud'
       scannerMode: 'MSBuild'
       projectKey: 'hamidhirsi70419_MyProject'
       projectName: 'MyProject'
 
    - task: TerraformTaskV4@4
      displayName: Tf init
      inputs:
        provider: 'azurerm'
        command: 'init'
        backendServiceArm: Azure
        backendAzureRmResourceGroupName: 'cloud-shell-storage-eastus'
        backendAzureRmStorageAccountName: 'tfbackend2024'
        backendAzureRmContainerName: 'tfbackend'
        backendAzureRmKey: 'prod.terraform.tfstate'

    - task: SonarCloudAnalyze@1
      inputs:
        jdkversion: 'JAVA_HOME_17_X64'

    - task: SonarCloudPublish@1
      inputs:
        pollingTimeoutSec: '60'

    - task: TerraformTaskV4@4
      displayName: Tf plan
      inputs:
        provider: 'azurerm'
        command: 'plan'
        commandOptions: '-out $(Build.SourcesDirectory)/tfplanfile'
        environmentServiceNameAzureRM: Azure
      
    - task: ArchiveFiles@2
      displayName: Archive files
      inputs:
        rootFolderOrFile: '$(Build.SourcesDirectory)/'
        includeRootFolder: false
        archiveType: 'zip'
        archiveFile: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId).zip'
        replaceExistingArchive: true

    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)'
        ArtifactName: '$(Build.BuildId)-build'
        publishLocation: 'Container'
```
## Release Pipeline:

![image](https://github.com/CloudHirsi/TFproject/assets/153539293/e99bd4f5-d5e2-4ff5-a76a-8f0f71c8dbc6)

## Deploy Stage

![image](https://github.com/CloudHirsi/TFproject/assets/153539293/9d33fb53-03c2-4d5b-9281-37b0d533a64d)

## Destroy Stage to Clean Up Resources

![image](https://github.com/CloudHirsi/TFproject/assets/153539293/2c926c92-f3b7-4c77-8b32-61cf44e98e20)




