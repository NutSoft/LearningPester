function HelloWorld($name='Pester') {
    return "Hello from $name"
}

function Get-TextFileName() {
    Get-ChildItem | Where-Object Name -like *.txt | Select-Object -ExpandProperty Name
}

function Get-Detail {
    return $env:USERDOMAIN, $env:USERNAME -join '\'
}