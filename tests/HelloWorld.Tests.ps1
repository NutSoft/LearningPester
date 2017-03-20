$srcFile = $MyInvocation.MyCommand.Path `
    -replace 'LearningPester\\tests\\(.*?)\.Tests\.ps1', `
             'LearningPester\src\$1.ps1' 
"$srcFile"
. $srcFile

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

Describe 'Get-TextFileNames' {
    
    It 'returns one text file when that is all there is' {
        $myList = 'a923e023.txt'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileNames | Should Be 'a923e023.txt'
    }
    
    It 'returns one text file when there are assorted files' {
        $myList = 'a923e023.txt','wlke93jw3.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileNames | Should Be 'a923e023.txt'
    }
    
    It 'returns multiple text files amongst assorted files' {
        $myList = 'a923e023.txt','wlke93jw3.doc','ke923jd.txt','qq02000.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileNames | Should Be ('a923e023.txt','ke923jd.txt')
    }
    
    It 'returns nothing when there are no text files' {
        $myList = 'wlke93jw3.doc','qq02000.doc'
        Mock Get-ChildItem { CreateFileList $myList }
        Get-TextFileNames | Should BeNullOrEmpty
    }
    
}
