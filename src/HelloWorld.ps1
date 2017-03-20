function HelloWorld($name='Pester') {
    return "Hello from $name"
}

function Get-TextFileNames() {
    Get-ChildItem | Where-Object Name -like *.txt | Select-Object -ExpandProperty Name
}
