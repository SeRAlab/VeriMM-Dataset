module top_module();typedef enum { a, b, c } enum_type;

enum_type enum_value;

assign enum_value = enum_type'(1);

endmodule