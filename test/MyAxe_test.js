const { contract, accounts } = require('@openzeppelin/test-environment');
// const { BN } = require('@openzeppelin/test-helpers');

const { expect } = require('chai');

const MyAxe = contract.fromArtifact('MyAxe');
/* const isSameMember = (_member, member) => {
  return _member[0] === member.name && _member[1] === member.tel;
};
*/

describe('MyAxe', function () {
  this.timeout(0);
  const NAME = 'InstruSafe';
  const SYMBOL = 'ISF';

  const USER1 = {
    name: 'Alice',
    tel: '01020304',
  };

  const [owner, dev, user1] = accounts;

  beforeEach(async function () {
    this.myaxe = await MyAxe.new(owner, { from: dev });
  });

  it('Has a name', async function () {
    expect(await this.myaxe.name()).to.equal(NAME);
  });
  it('Has a symbol', async function () {
    expect(await this.myaxe.symbol()).to.equal(SYMBOL);
  });

  /*
  it('add and get Member data', async function () {
    await this.app.createMember(USER1.name, USER1.tel, { from: user1 });
    // await this.app.createMember(USER2.name, USER2.tel, { from: user2 });

    const _member1 = await this.app.getMember(user1);
    // const _member2 = await this.app.getMember(user2);
    expect(isSameMember(_member1, USER1)).to.be.true;
    // expect(isSameMember(_member2, USER2)).to.be.true;
  });
  */

  it('Member created', async function () {
    await this.MyAxe.createMember(USER1[0], USER1[1], {
      from: user1,
    });
    const UserNew1 = await this.MyAxe.getMember({ from: user1 });
    expect(UserNew1[0]).to.equal(USER1[0]);
    expect(UserNew1[1]).to.equal(USER1[1]);
  });
});
