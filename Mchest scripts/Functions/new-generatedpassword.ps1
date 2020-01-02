Function New-GeneratedPassword {
    <#
    Company Password policy

    - 8 character minimum
    - Complexity enabled
    - Cannot contain sAMAccountName
    - Cannot contain givenname or surname
    #>

    # Exclude similar characters
    $CharacterPool = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#$%^&*()<>?+=" -Split '' | Where-Object {$_ -ne ''}

    # Generate 10 character password
    $GeneratedPassword = (Get-Random -InputObject $CharacterPool -Count 10) -join ''

    # Check that the password conforms to complexity requirements
    if ($GeneratedPassword -cmatch "[A-Z\p{Lu}\s]" -and $GeneratedPassword -cmatch "[a-z\p{Ll}\s]" -and $GeneratedPassword -match "[\d]" -and $GeneratedPassword -match "[^\w]") {
        return $GeneratedPassword
    }
    else {
        # Retry generating password if it does not conform to complexity requirements
        return New-GeneratedPassword
    }
}