from brownie import CrossChainNftDest, config, network
from scripts.helpful_scripts import get_account


def main():
    cc_dest, account = deploy_new_contract()
    # cc_dest, account = deploy_contract()


def deploy_contract():
    account = get_account()
    if len(CrossChainNftDest) > 0:
        cc_dest = CrossChainNftDest[-1]
    else:
        cc_dest = CrossChainNftDest.deploy(
            config["networks"][network.show_active()]["layer_zero"],
            {"from": account},
            publish_source=True,
        )
    return cc_dest, account


def deploy_new_contract():
    account = get_account()
    cc_dest = CrossChainNftDest.deploy(
        config["networks"][network.show_active()]["layer_zero"],
        {"from": account},
        publish_source=True,
    )
    return cc_dest, account
