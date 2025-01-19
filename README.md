# Azure AD Manager

A PowerShell-based tool for managing Azure AD users, providing functionality for user creation and sign-in management.

## Features

- Create new users from CSV file
- Block user sign-ins from CSV file
- Create VPN users with specific configurations
- Automatic logging of all operations
- Interactive menu-driven interface

## Directory Structure

```
AzureADManager/
├── scripts/
│   ├── create_users.ps1     # User creation script
│   ├── block_sign_in.ps1    # Sign-in blocking script
│   └── vpn_user_creation.ps1 # VPN user creation script
├── output/                  # All operation logs are stored here
├── auth.ps1                 # Authentication module
└── main.ps1                 # Main program script
```

## CSV File Format

### For User Creation
Required columns in the CSV file:
- DisplayName
- UserPrincipalName
- Password
- FirstName
- LastName
- EmployeeId
- Department
- OfficeLocation
- UsageLocation
- BusinessPhone
- CompanyName

### For VPN User Creation
Required columns in the CSV file:
- DisplayName
- UserPrincipalName
- Password
- FirstName
- LastName
- EmployeeId
- UsageLocation
- EmployeeType

### For Blocking Sign-in
Required columns in the CSV file:
- userPrincipalName

## Output Files

All operation logs are automatically saved in the `output` directory with the following naming convention:
- User Creation: `user_creation_output_YYYYMMDD_HHMMSS.txt`
- Block Sign-in: `block_signin_output_YYYYMMDD_HHMMSS.txt`
- VPN User Creation: `vpn_user_creation_output_YYYYMMDD_HHMMSS.txt`

## Usage

1. Run `main.ps1` to start the program
2. Choose the desired operation from the menu:
   - Option 1: Create standard users
   - Option 2: Block user sign-ins
   - Option 3: Create VPN users
3. When prompted, provide the path to your CSV file
4. The operation will be performed and logged automatically
5. Check the output directory for detailed operation logs

## Requirements

- PowerShell 5.1 or higher
- Microsoft.Graph PowerShell module
- Azure AD administrator privileges

## Error Handling

- All operations are logged, including both successful and failed actions
- Detailed error messages are provided in the logs
- Real-time feedback is displayed in the console during operations
- Summary reports show success/failure counts for each operation
