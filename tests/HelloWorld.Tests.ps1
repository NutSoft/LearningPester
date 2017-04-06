$srcFile = $MyInvocation.MyCommand.Path `
    -replace 'LearningPester\\tests\\(.*?)\.Tests\.ps1', `
             'LearningPester\src\$1.ps1'
"$srcFile"
. $srcFile

Describe 'PowerShell Basic Check' {

  Context 'PS Versioning'   {
    It 'is current version' {
        if($host.Name -eq 'Visual Studio Code Host') {
            $host.Version.Major -ge 1 -and $host.Version.Minor -ge 0 | Should Be $true
        }
        else {
            $host.Version.Major -ge 5 -and $host.Version.Minor -ge 1 | Should Be $true
        }
    }
  }
  Context 'PS Settings'   {
    It 'can execute scripts' {
      (Get-ExecutionPolicy) | Should Not Be 'Restricted'
    }
    It 'does not use AllSigned' {
      (Get-ExecutionPolicy) | Should Not Be 'AllSigned'
    }
    It 'does not have GPO restrictions' {
      (Get-ExecutionPolicy -Scope MachinePolicy) | Should Be 'Undefined'
      (Get-ExecutionPolicy -Scope UserPolicy) | Should Be 'Undefined'
    }
  }
}

Describe "HelloWorld" {
    It "does something useful" {
        $true | Should Be $true
    }
    It "with no input returns a canonical phrase" {
        HelloWorld | Should Be "Hello from Pester"
    }
    It "with a name returns the standard phrase with that name" {
        HelloWorld "Venus" | Should Be "Hello from Venus"
    }
    It "with a name returns something that ends with name" {
        HelloWorld "Mars" | Should Match ".*Mars"
    }
}

function CreateFileList([string[]]$names) {
    $names | ForEach-Object {
        [PSCustomObject]@{ FullName = "c:\foo\bar\$_"; Name = $_; }
    }

}

Describe 'Get-TextFileName' {

    It 'returns one text file when that is all there is' {
        $myList = 'a923e023.txt'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileName | Should Be 'a923e023.txt'
    }

    It 'returns one text file when there are assorted files' {
        $myList = 'a923e023.txt','wlke93jw3.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileName | Should Be 'a923e023.txt'
    }

    It 'returns multiple text files amongst assorted files' {
        $myList = 'a923e023.txt','wlke93jw3.doc','ke923jd.txt','qq02000.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileName | Should Be ('a923e023.txt','ke923jd.txt')
    }

    It 'returns nothing when there are no text files' {
        $myList = 'wlke93jw3.doc','qq02000.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileName | Should BeNullOrEmpty
    }

}

function GetFilesLackingItem([string]$pattern) {
    $filesFound = Get-ChildItem -Recurse *.csproj |
    Where-Object { !( Select-String -Pattern $pattern -Path $_.FullName ) }
    if ($filesFound) { $filesFound.Name } else { @() }
}

Describe "GetFilesLackingItem" {
    Context "checks some files" {
        It "reports subset of files missing item" {
            $fileList = "nameA", "nameB", "nameC", "nameD", "nameE" | ForEach-Object {
                [PSCustomObject]@{ FullName = $_; Name = $_; }
            }

            Mock Get-ChildItem { return $fileList }
            $filter = '(B|D|E)$'
            Mock Select-String { "matches found" }  -param { $Path -match $filter }
            Mock Select-String

            $result = GetFilesLackingItem "dummy"

            $result.Count | Should Be ($fileList.Name -notmatch $filter).Count
        }
    }
}

Describe "SimpleTest" {
    Context "whatever" {
        It "must do something" {

        }
    }
}
