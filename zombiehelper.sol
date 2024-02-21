pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // calldata is similar to memory, but it's only available to external functions
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    // view functions don't cost any gas when they're called externally by a user.
    // If a view function is called internally from another function in the same contract that is not a view function
    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        // Use to keep track of the index in result array
        uint counter = 0;

        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
