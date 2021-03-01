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

resource "local_file" "several_outputs" {
  filename = "several_output.txt"
  content = "There will be a 3 copies of this on top of each other"
  count = 3
}

# The proper use of count
variable "filenames" {
    default = [
        "/root/dog.txt",
        "/root/cat.txt",
        "/pet.txt"
    ]
}
// length is a built in function that returns the length of the array.
resource "local_file" "several_outputs" {
  filename = var.filenames[count.index]
  content = "There will be a 3 copies of this on top of each other"
  count = length(var.filenames)
}


# For each

variable "filenames" {
    type = list(string)
    default = [
        "/root/dog.txt",
        "/root/cat.txt",
        "/pet.txt"
    ]
}

variable "filename_set" {
    type = set(string)
    default = [
        "/root/dog.txt",
        "/root/cat.txt",
        "/pet.txt"
    ]
}
// for_each only works with set and maps. filenames is list of strings. 

# DOES NOT WORK!
resource "local_file" "several_outputs" {
  filename = each.value
  for_each = var.filenames
}

# DOES WORK

# This works because filename_set is a set.
resource "local_file" "several_outputs" {
  filename = each.value
  for_each = var.filename_set
}
# You either need to use set or another builin function toset to convert list to set
resource "local_file" "several_outputs" {
  filename = each.value
  for_each = toset(var.filenames)
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