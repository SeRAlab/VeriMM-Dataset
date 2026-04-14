module top_module( 
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:3] out_not_b,
    output [2:0] out_not_a,
    output [2:0] out_xor
);// Perform bitwise OR operation on a and b
    wire [2:0] bitwise_or = a | b;
    
    // Perform logical OR operation on a and b
    wire logical_or = |{a,b};
    
    // Invert a and b
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    
    // Assign outputs
    assign out_or_bitwise = bitwise_or;
    assign out_or_logical = logical_or;
    assign out_not_a = not_a;
    assign out_not_b = {1'b0, not_b};
    
    // Perform XOR operation on outputs of OR operations
    assign out_xor = bitwise_or ^ logical_or;
    
endmodule