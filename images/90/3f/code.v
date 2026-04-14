module top_module(
    input [3:0] in,
    input [2:0] a,
    input [2:0] b,
    output out_nand,
    output out_nor,
    output out_xnor,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output out_final
);// Combinational circuit
    wire nand_output = ~(in[0] & in[1] & in[2] & in[3]);
    wire nor_output = ~(in[0] | in[1] | in[2] | in[3]);
    wire xnor_output = ~(in[0] ^ in[1] ^ in[2] ^ in[3]);
    
    // Bitwise OR and logical OR module
    wire [2:0] or_bitwise_output = {a[0] ^ b[0], a[1] ^ b[1], a[2] ^ b[2]};
    wire or_logical_output = |{a, b};
    
    // NOT gate for inverting input vectors
    wire [3:0] a_not = ~a;
    wire [3:0] b_not = ~b;
    
    // Output inverted values of a and b
    assign out_not = {b_not[2:0], a_not[2:0]};
    
    // Functional module
    wire final_output = nand_output | nor_output | xnor_output | or_logical_output | |or_bitwise_output;
    
    // Assign outputs
    assign out_nand = nand_output;
    assign out_nor = nor_output;
    assign out_xnor = xnor_output;
    assign out_or_bitwise = or_bitwise_output;
    assign out_or_logical = or_logical_output;
    assign out_final = final_output;
    
endmodule