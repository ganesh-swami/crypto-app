const Tether = artifacts.require("Tether");
const RWD = artifacts.require("RWD");
const DecentralBank = artifacts.require("DecentralBank");

require('chai').use(require('chai-as-promised')).should();

contract('DecentralBank', function ([owner,customer]) { // accounts[0] is the owner of the contract and accounts[1] is the customer and we got accounts as parameter here

    let tether, rwd, decentralBank;

    function tokens(number) {
        return web3.utils.toWei(number.toString(), 'ether');
    }

    before(async () => {
        tether = await Tether.new()
        rwd = await RWD.new()
        decentralBank = await DecentralBank.new(rwd.address, tether.address)
        await rwd.transfer(decentralBank.address, tokens('1000000'));

        // transfer 100 tethers to customer
        await tether.transfer(customer, tokens('100'), {from: owner});

    })

    describe('Tether Deployment',async ()=>{
        it('Tether Name Matched Successfully', async ()=>{
            const name = await tether.name()
            assert.equal(name, 'Tether')
        })
    })

    describe('RWD Deployment',async ()=>{
        it('RWD Name Matched Successfully', async ()=>{
            const name = await rwd.name()
            assert.equal(name, 'Reward Token')
        })
    })

    describe('DecentralBank Deployment',async ()=>{
        it('DecentralBank Name Matched Successfully', async ()=>{
            const name= await decentralBank.name()
            assert.equal(name, 'Decentral Bank')
        })

        it('contract has tokens', async ()=>{
            let balance = await rwd.balanceOf(decentralBank.address) // get the balance of the contract
            assert.equal(balance.toString(), tokens('1000000'))

        })
    })


    describe('Yield Farming', async () => {
        it('rewards tokens for stacking', async () => {
            let investorBalanceBefore;

            // check investor balance before transaction
            investorBalanceBefore = await tether.balanceOf(customer);
            assert.equal(investorBalanceBefore.toString(), tokens('100'), 'investor has 100 tokens');

            // check stacking for customer
            await tether.approve(decentralBank.address, tokens('100'), { from: customer });
            await decentralBank.depositTokens(tokens('100'), {from: customer});



            // check investor balance after transaction
            let investorBalanceAfter = await tether.balanceOf(customer);
            assert.equal(investorBalanceAfter.toString(), tokens('0'), 'investor has 0 tokens');

            // check updated balance of decentral bank
            let bankBalance = await tether.balanceOf(decentralBank.address);
            assert.equal(bankBalance.toString(), tokens('100'), 'bank has 100 tokens');

            // check updated isStaking value
            let isStaking = await decentralBank.isStacking(customer);
            assert.equal(isStaking, true, 'customer is staking');

            // issue rewards
            await decentralBank.issueRewards({from: owner});

            // ensure only owner can issue rewards
            await decentralBank.issueRewards({from: customer}).should.be.rejectedWith('revert');

        })

        

    })
}) 
