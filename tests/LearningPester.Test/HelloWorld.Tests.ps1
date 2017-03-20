$srcFile = $MyInvocation.MyCommand.Path `
    -replace 'LearningPester\\tests\\(.*?)\.Test\\(.*?)\.Tests\.ps1', `
             'LearningPester \src\$1\$2.ps1' 
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
