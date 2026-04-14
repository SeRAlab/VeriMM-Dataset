module top_module( 
    input [2:0] a,
    input [2:0] b,
    input clk,                       // Added the clock input
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);wire [2:0] a_inv, b_inv;
    wire [2:0] or_bitwise;
    wire or_logical;

    // Pipeline registers
    reg [2:0] a_reg, b_reg;
    reg [2:0] a_inv_reg, b_inv_reg;
    reg [2:0] or_bitwise_reg;
    reg or_logical_reg;
    
    // Lookup table for bitwise OR
    assign or_bitwise = {a[0] | b[0], a[1] | b[1], a[2] | b[2]};
    
    // Logical OR
    assign or_logical = (a | b) != 0;
    
    // Inverse of a and b
    assign {b_inv[2], b_inv[1], b_inv[0]} = ~b;
    assign {a_inv[2], a_inv[1], a_inv[0]} = ~a;

    // Pipeline stages
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        a_inv_reg <= a_inv;
        b_inv_reg <= b_inv;
        or_bitwise_reg <= or_bitwise;
        or_logical_reg <= or_logical;
    end
    
    // Output stage
    assign out_or_bitwise = or_bitwise_reg;
    assign out_or_logical = or_logical_reg;
    assign {out_not[5], out_not[4], out_not[3]} = b_inv_reg;
    assign {out_not[2], out_not[1], out_not[0]} = a_inv_reg;
    
endmodule