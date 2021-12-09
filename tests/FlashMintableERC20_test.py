#!/usr/bin/python3
import pytest
from brownie import accounts

@pytest.fixture(scope="module")
def token(FlashMintableERC20):
    return accounts[0].deploy(FlashMintableERC20, 100e18)

@pytest.fixture(scope="module")
def borrower(Borrower, token):
    return accounts[0].deploy(Borrower, token, accounts[1])

def test_flashMint(borrower, token, accounts):
    borrower.beginFlashMint(1e18, {'from': accounts[1]})
    assert token.totalSupply() == 100e18