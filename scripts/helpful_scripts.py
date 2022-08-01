from brownie import (
    network,
    config,
    accounts,
    Contract,
    interface,
)


FORKED_BLOCKCHAIN = ["mainnet-fork"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account(index=None, name=None):
    if index:
        return accounts[index]
    if name:
        return accounts.add(config["wallets"][name])
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_BLOCKCHAIN
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["DEV01"])
