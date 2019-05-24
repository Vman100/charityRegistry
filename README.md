# charityRegistry
The use case for the contract is the traceability of donations to the list of charities that an organization preregisters into the contract. The donated funds are temporarily held by the contract until they are released to the respective charities.

## functions

There are five public functions available for interaction with the contract two of which are getter functions and one payable function.

The **registryCharity** function accepts two arguments, a string and an address. calling this function registers the name and address of a charity while triggering an event containing the details of the registered charity. No return value is expected and only the contract owner can call this function.

The **Donate** function accepts one argument, an address, and is payable. calling this function any address to donate funds to a preregistered list of charities with the selected charity info and donation amount mapped to the donater's address while triggering an event containing the donater's address, selected charity info, and donation amount. No return value is expected.

The **releaseFunds** function accepts no arguments. calling this function will cause the contract balance to be released and split up based on the cumulative amount donated to each registered charity since this function was last called with the amounts reset to zero per call. No return value is expected and only the contract owner can call this function.

The **getDonationInfo** function accepts one argument, an uint. calling this function returns the charity address and cumulative donation amount mapped the donater's address based on the provided uint index. the donation amount is never reset.

The **listRegisteredAddr** function accepts no arguments. calling this function will return an array of preregistered charity addresses.

There are three private functions used for finding and updating the individual charity records along with checking if an address is already registered or not.

## contract link

https://ropsten.etherscan.io/address/0xbd9fd200b77bf6d19a36a697e6b8f7fd52f476ac


