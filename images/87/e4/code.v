module top_module(
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] out_nand,
    output wire [7:0] out_or,
    output wire [3:0] out_prod,
    output wire [3:0] out_quot);assign out_nand = ~(A & B);
    assign out_or = A | B;
    
    // Product
    wire [15:0] product = A * B;
    assign out_prod = product[7:4];
    
    // Quotient
    wire [15:0] quotient;
    assign quotient = (B == 0) ? 0 : A / B;
    assign out_quot = quotient[7:4];
    
endmodule