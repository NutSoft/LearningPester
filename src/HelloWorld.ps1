function HelloWorld($name='Pester') {
    return "Hello from $name"
}

function Get-TextFileNames() {
    Get-ChildItem | Where Name -like *.txt | Select -expand Name
}
