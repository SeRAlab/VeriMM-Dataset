module dot_product (
    input [3:0] A0, A1, A2, A3, A4,
    input [3:0] B0, B1, B2, B3, B4,
    output [9:0] result
);
    wire [7:0] prod0, prod1, prod2, prod3, prod4;
    
    assign prod0 = A0 * B0;
    assign prod1 = A1 * B1;
    assign prod2 = A2 * B2;
    assign prod3 = A3 * B3;
    assign prod4 = A4 * B4;

    assign result = prod0 + prod1 + prod2 + prod3 + prod4;
endmodule