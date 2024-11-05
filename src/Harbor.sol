import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Harbor is Ownable {

  mapping (address => uint) indexes = {};

}