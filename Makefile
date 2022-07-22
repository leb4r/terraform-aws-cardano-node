.PHONY: clean pre-commit

clean:
	@find . \( -name .terraform.lock.hcl -type f \) -o \( -name .terraform -type d \)| xargs rm -rfv

pre-commit:
	pre-commit install
	pre-commit run --all
