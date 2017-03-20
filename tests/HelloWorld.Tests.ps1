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

Describe 'Get-TextFileNames' {
    
    It 'returns one text file when that is all there is' {
        Mock Get-ChildItem {
                [PSCustomObject]@{ Name = 'a923e023.txt' }
        }
        Get-TextFileNames | Should Be 'a923e023.txt'
    }
    
    It 'returns one text file when there are assorted files' {
        Mock Get-ChildItem {
            [PSCustomObject]@{ Name = 'a923e023.txt' },
            [PSCustomObject]@{ Name = 'wlke93jw3.doc' }
        }
        Get-TextFileNames | Should Be 'a923e023.txt'
    }
    
    It 'returns multiple text files amongst assorted files' {
        Mock Get-ChildItem {
            [PSCustomObject]@{ Name = 'a923e023.txt' },
            [PSCustomObject]@{ Name = 'wlke93jw3.doc' },
            [PSCustomObject]@{ Name = 'ke923jd.txt' },
            [PSCustomObject]@{ Name = 'qq02000.doc' }
        }
        Get-TextFileNames | Should Be ('a923e023.txt','ke923jd.txt')
    }
    
    It 'returns nothing when there are no text files' {
        Mock Get-ChildItem {
            [PSCustomObject]@{ Name = 'wlke93jw3.doc' },
            [PSCustomObject]@{ Name = 'qq02000.doc' }
        }
        Get-TextFileNames | Should BeNullOrEmpty
    }
    
}
