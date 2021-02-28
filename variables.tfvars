
# Map of strings
variable "my_map" {
    type = map(string)
    description = "(optional) describe your variable"
    default = {
        key1 = "val1"
        key2 = "val2"
    }
}
/*

you reference it by 

var.my_map['key1']

*/