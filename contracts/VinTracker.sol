//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

error VinTracker__OnlySubmitterMayEdit(address submitter);

contract VinTracker {
  string private vin;

  struct Info {
    address submitter; // msg.sender who submitted info
    uint40 timestamp; // used to keep track of when repairs were made
    uint40 id; // index in Info array
    string desc; // probably will be a URI more often then not
  }

  Info[] private InfoArray;

  //mapping(uint40 => Info) infoMapping; // decided to use array instead b/c iteration and .length vs using seperate counter uint.

  constructor(string memory _vin) {
    vin = _vin;
  }

  /**@dev Main function which allows users to submitInfo to a certain car VIN number, their submission is saved inside an array of
   * Info structs.
   */
  function submitInfo(
    uint40 timestamp,
    string memory desc
  ) public returns (uint40 index) {
    Info memory info = Info(
      msg.sender,
      timestamp,
      uint40(InfoArray.length),
      desc
    );
    InfoArray.push(info);
    index = uint40(InfoArray.length - 1);
  }

  /**@dev This function is here incase the submitter needs to revise any Info or timestamp
   * May pass a '0' to keep original variable
   */
  function changeInfo(
    uint index,
    uint40 newTimestamp,
    string memory newDesc
  ) public {
    if (msg.sender != InfoArray[index].submitter) {
      revert VinTracker__OnlySubmitterMayEdit(InfoArray[index].submitter);
    }
    if (newTimestamp != 0) {
      InfoArray[index].timestamp = newTimestamp;
    }
    if (
      keccak256(abi.encodePacked(newDesc)) != keccak256(abi.encodePacked("0"))
    ) {
      InfoArray[index].desc = newDesc;
    }
  }

  /**@dev view/pure */

  function viewInfo(uint index) public view returns (Info memory) {
    return InfoArray[index];
  }

  function viewInfoArrayLength() public view returns (uint40) {
    return uint40(InfoArray.length);
  }
}
