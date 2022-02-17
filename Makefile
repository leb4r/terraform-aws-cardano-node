.PHONY: clean

clean:
	@find . \( -name .terraform.lock.hcl -type f \) -o \( -name .terraform -type d \)| xargs rm -rfv
