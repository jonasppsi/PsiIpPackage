# Command Reference

**_EXAMPLE DRAFT_**

```
namespace import psi::ip_package::latest::*
```


# Command Links

| **Command**                                       | **Description** | **2017.2** | 2020.1 | 2022.1 |
| ----                                              | ----            | :----:     | :----: | :----: |
| _General Commands_                                |                 |            |        |        |
| [init](#init)                                     |                 | X          | X      | X      |
| _Configuration Commands_                          |                 |            |        |        |
| [version_check](#version_check)                   |                 | X          | X      | X      |
| [set_description](#set_description)               |                 | X          | X      | X      |
| [set_vendor](#set_vendor)                         |                 | X          | X      | X      |
| [set_vendor_short](#set_vendor_short)             |                 | X          | X      | X      |
| [set_vendor_url](#set_vendor_url)                 |                 | X          |        | X      |
| [set_logo_relative](#set_logo_relative)           |                 |            |        | X      |
| [set_datasheet_relative](#set_datasheet_relative) |                 |            |        | X      |
| _Run Commands_                                    |                 |            |        |        |
| [package_ip](#package_ip)                         |                 | X          | X      | X      |


## General Commands

### init
<div align="right"><font color="green" size="2">2017.2 | 2020.1 | 2022.1</font></div>

**Usage**

```
init <name> <version> <revision> <library>
```

**Description**

This command initializes the PSI IP packaging module. It must be called as first command from this library
in every packaging script.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> name </td>
      <td> No </td>
      <td> Name of the IP Core. The name cannot special characters. </td>
    </tr>
    <tr>
      <td> version </td>
      <td> No </td>
      <td> Version of the IP-Core in the form "1.2" </td>
    </tr>	
    <tr>
      <td> revision </td>
      <td> No </td>
      <td> Revision of the IP-core. Alternative to passing a number, the string "auto" can be passed. In this
           case the UNIX timestamp of the build time is taken as revision which results in an automatically
           updated and unique revision number. As a result, Vivado detects a new revision every time time
		   IP core is packaged. </td>
    </tr>		
</table>

## Configuration Commands

### set_description
**Usage**

```
set_description <desc>
```

**Description**

Set the description of the IP-Core that is shown in Vivado.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> desc </td>
      <td> No </td>
      <td> Description of the IP-Core </td>
    </tr>
</table>

### set_vendor
**Usage**

```
set_vendor <vendor>
```

**Description**

Set the vendor of the IP-Core that is shown in Vivado.

This command is optional. If it is not used, the vendor name is set to \"Paul Scherrer Institute\". This is chosen this way to make the code
fully reverse compatible.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> vendor </td>
      <td> No </td>
      <td> Vendor of the IP-Core </td>
    </tr>
</table>

### set_vendor_short
**Usage**

```
set_vendor_short <vendor>
```

**Description**

Set the vendor abbreviation of the IP-Core that is shown in Vivado. Note that hte vendor abbreviation is not allowed to contain any whitespaces.

This command is optional. If it is not used, the vendor abbreviation is set to \"psi.ch\". This is chosen this way to make the code
fully reverse compatible.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> vendor </td>
      <td> No </td>
      <td> Vendor abbreviation (no whitespaces allowed) </td>
    </tr>
</table>

### set_vendor_url
**Usage**

```
set_vendor_url <url>
```

**Description**

Set the vendor URL of the IP-Core that is shown in Vivado.

This command is optional. If it is not used, the vendor url is set to \"www.psi.ch\". This is chosen this way to make the code
fully reverse compatible.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> url </td>
      <td> No </td>
      <td> Vendor URL of the IP-Core </td>
    </tr>
</table>

### set_logo_relative
**Usage**

```
set_logo_relative <logo>
```

**Description**

Add a logo to the IP-Core. The logo is not copied into the IP-Core but referenced relatively.

**Parameters**
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> logo </td>
      <td> No </td>
      <td> Path to the logo. </td>
    </tr>
</table>

### set_datasheet_relative
**Usage**

```
set_datasheet_relative <datasheet>
```

**Description**

Add a Datasheet to the IP-Core. The datasheet is not copied into the IP-Core but referenced relatively.

**Parameters**  

<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> datasheet </td>
      <td> No </td>
      <td> Path to the datasheet. </td>
    </tr>
</table>

### set_taxonomy
**Usage**

```
set_taxonomy <groups>
```

**Example**

```
set_taxonomy {/AXI_Infrastructure /Communication_&_Networking/Ethernet /my_new_group}
```

**Description**

A custom taxonomy (display grouping in the IP Catalog) can be added by this command. Each IP can be represented in one or multiple groups. The command expects a list of groups as parameter. Groups can be split into sub-groups by using a "file" like structure */main_group/sub_group*. Unknown groups are automatically created by Vivado.

**Parameters**

<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> taxonomy </td>
      <td> No </td>
      <td> List of taxonomy groups. </td>
    </tr>
</table>

### set_top_entity
**Usage**

```
set_top_entity <entity_name>
```

**Description**

Usually Vivado automatically detects the top entity name. If this works, the command *set_top_entity* can be omitted. Otherwise it can be used to specify the top level entity.

**Parameters**  
<table>
    <tr>
      <th width="200"><b>Parameter</b></th>
      <th align="center" width="80"><b>Optional</b></th>
      <th align="right"><b>Description</b></th>
    </tr>
    <tr>
      <td> entity_name </td>
      <td> No </td>
      <td> Name of the top level entity</td>
    </tr>
</table>

