const { contract, accounts} = require('@openzeppelin/test-environment');
const GameContract = contract.fromArtifact('GameToken');
let assert = require("assert");

[owner, sender] = accounts;

describe("game main contract", function(){
    it('deploy game contract', async function(){
        GAMEParams= ["BMT"]
        GameInstance = await GameContract.new({from: owner});
    });
});

describe("test game contract", function(){
    it('symbol: symbol()', async function () {
        assert.equal(GAMEParams[0], await GameInstance.symbol());
    });
})
