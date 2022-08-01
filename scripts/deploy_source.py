from brownie import CrossChainNft, config, network
from scripts.helpful_scripts import get_account


def main():
    cc_source, account = deploy_new_contract()
    # cc_source, account = deploy_contract()


def deploy_contract():
    account = get_account()
    if len(CrossChainNft) > 0:
        cc_source = CrossChainNft[-1]
    else:
        cc_source = CrossChainNft.deploy(
            config["networks"][network.show_active()]["layer_zero"],
            {"from": account},
            publish_source=True,
        )
    return cc_source, account


def deploy_new_contract():
    account = get_account()
    cc_source = CrossChainNft.deploy(
        config["networks"][network.show_active()]["layer_zero"],
        {"from": account},
        publish_source=True,
    )
    return cc_source, account
