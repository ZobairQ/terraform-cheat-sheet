# Create a simple resource

resource "local_file" "pet" {
  filename  = "/root/pet.txt"
  content = "The specific name of my pet."
}

# Create variables
variable "name_of_pet" {
  description = "This variable contains the name of my pet"
  default = "tingy"
}

# reference a variable name inside resource block and variable_pet file depends on the variable name_of_pet
resource "local_file" "variable_pet" {
    filename = "/root/variable_pet.txt"
    content = var.name_of_pet
    depends_on = [ var.name_of_pet ]
}

# reference a variable concatinate it with other text
resource "local_file" "concat_variable_pet" {
    filename = "concat_variable_pet.txt"
    content = "The name of my pet is Mr. ${var.name_of_pet}"
}

# meta arguments
# lifecycle 
resource "local_file" "important_file" {
    filename = "imp.txt"
    content = "This is super sectret and important file"

    # This ensures that another resource is created before this one is destroyed on changes
    lifecycle {
      create_before_destory = true
    }
  
}

resource "local_file" "important_file" {
    filename = "imp.txt"
    content = "This is super sectret and important file"

    # This ensures that this resource is not destroyed on apply.
    lifecycle {
        prevent_destroy = true
    }
}

# Output 
variable "name" {
  type        = string
  description = "This is a name for a character"
  default     = "John Aley"
}

output "name" {
  depends_on = [var.name]
  value      = var.name
}

# Data sources
data "local_file" "dog" {
  filename = "/root/dog.txt"
}

# Reference data source
resource "local_file" "dog" {
  filename = "/root/dog2.txt"
  content  = data.local_file.dog.content
}