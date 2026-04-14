module top_module(
    input [15:0] A,
    input [15:0] B,
    output [31:0] out
);wire [31:0] product [15:0];

genvar i, j;

generate
    for (i = 0; i < 16; i = i + 1) begin : row
        assign product[i] = {16'b0, A[i]} * {16'b0, B};
    end
endgenerate

assign out = product[0];
generate
    for (j = 1; j < 16; j = j + 1) begin : column
        assign out = out + (product[j] << j);
    end
endgenerate

endmodule