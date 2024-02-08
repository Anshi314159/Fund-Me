-include .env

.PHONY: test clean deploy fund help install snapshot format anvil 

help:
	@echo "Usage:"
	@echo "  make deploy-[ARGS=...]    "
	@echo "  	example: make deploy ARGS=\"sepolia\" or ARGS=\"ganache\""
	@echo ""
	@echo "  make fund-[ARGS=...]    "
	@echo "      example: make deploy ARGS=\"anvil\""





#sepolia
deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL_S) --private-key $(PRIVATE_KEY_S) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv


#ganache
deploy-ganache:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL_G) --private-key $(PRIVATE_KEY_G) --broadcast


#anvil
deploy-anvil:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL_A) --private-key $(PRIVATE_KEY_A) --broadcast 

fund-anvil:
	@forge script script/Interactions.s.sol:FundFundMe --rpc-url $(RPC_URL_A) --private-key $(PRIVATE_KEY_A) --broadcast 

withdraw-anvil:
	@forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(RPC_URL_A) --private-key $(PRIVATE_KEY_A) --broadcast 



# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.0.11 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit

