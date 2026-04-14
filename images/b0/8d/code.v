module top_module(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not,
    output out_nor,
    output out_and
);// Bitwise OR
    assign out_or_bitwise = a | b;
    
    // Logical OR
    assign out_or_logical = (a != 0) || (b != 0);
    
    // NOT
    assign out_not = {~a, ~b};
    
    // NOR
    wire [2:0] nand_out;
    assign nand_out = ~(a & b);
    assign out_nor = ~(nand_out[0] & nand_out[1] & nand_out[2]);
    
    // AND
    assign out_and = out_or_logical & out_nor;

endmodule