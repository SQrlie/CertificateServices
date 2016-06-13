function New-X500DistinguishedName {
    <#
    .SYNOPSIS
        Returns an X500DistinguishedName object
    .DESCRIPTION
        
    .PARAMETER CN
        Common Name. A required component that identifies the person or object defined by the entry.
    .PARAMETER E
        Email address (deprecated). Identifies the email address of the entry.
    .PARAMETER OU
        Organizational Unit. Identifies a unit within the organization.
        Several organizational units can be specified by using a comma delimited list.
    .PARAMETER O
        Organization. Identifies the organization in which the entry resides.
    .PARAMETER L
        Locality. Identifies the place where the entry resides. The locality can be a city, county, township, or other geographic region.
    .PARAMETER ST
        State or province name. Identifies the state or province in which the entry resides.
    .PARAMETER C
        Country. Identifies the name of the country under which the entry resides.
        Two-letter country code in accordance with th eISO 3166-1 A-2 standard.
    .PARAMETER DC
        Domain component. Identifies the domain components of a domain. 
        Several domain components can be specified by using a comma delimited list.
    .PARAMETER T
        Title.
    .PARAMETER G
        Given Name.
    .PARAMETER SN
        Surname.
    .PARAMETER I
        Initials.
    .PARAMETER Street
        Street Address.
    .EXAMPLE
        New-X500DistinguishedName -CN CONTOSO-DC1
        Returns an X500DistinguishedName with the Common Name "CONTOSO-DC1"
    .EXAMPLE
        New-X500Distinguishedname -CN CONTOSO-SRV1 -OU SRV1,Servers -DC contoso,com
        Returns the distinguished name CN=CONTOSO-SRV1,OU=SRV1,OU=Servers,DC=contoso,DC=com
    .NOTES
        Author: Andreas Sørlie
        Date: 13.06.2016
        Version: 1.0
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipelineByPropertyName=$True)]
            [Alias('CommonName')]
            [String]$CN,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('Email')]
            [String]$E,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('OrganizationalUnit')]
            [String]$OU,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('Organization')]
            [String]$O,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('Locality')]
            [String]$L,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('State')]
            [String]$ST,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [ValidateScript({
                $_.Length -eq 2 -and $_ -Match '^[A-Za-z]{2}$'
            })]
            [Alias('Country')]
            [String]$C,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('DomainComponent')]
            [String]$DC,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('Title')]
            [String]$T,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('GivenName')]
            [String]$G,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('SurName')]
            [String]$SN,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('Initials')]
            [String]$I,
        [Parameter(Mandatory=$False,ValueFromPipelineByPropertyName=$True)]
            [Alias('StreetAddress')]
            [String]$Street
    )
    $ErrorActionPreference ='Stop'
    $SubjectObject = New-Object -ComObject X509Enrollment.CX500DistinguishedName
    $Subject = @()
    $CommandName = $PSCmdlet.MyInvocation.InvocationName
    $ParameterList = (Get-Command -Name $CommandName).Parameters
    $Attributes = Get-Variable -Name $ParameterList.Values.Name -ErrorAction SilentlyContinue
    foreach ($Attribute in $Attributes) {
        if ($Attribute.Value -eq $Null -or $Attribute.Value.Length -lt 1) {
            Continue
        }
        $AttributeValues = $Attribute.Value.Split(',')
        foreach ($AttributeValue in $AttributeValues) {
            $Subject += "$($Attribute.Name)=$AttributeValue"
        }
    }
    $Subject = $Subject -Join ','
    $SubjectObject.Encode($Subject, 0x0)
    return $SubjectObject
}
