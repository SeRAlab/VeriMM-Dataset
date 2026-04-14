module top_module(
    input CI,
    output [3:0] O,
    output CO,
    input CYINIT,
    input [3:0] DI,
    input [3:0] S
);wire [3:0] C; // carry-out bits from each CARRY4 gate

// Simple carry look-ahead implementation
wire [4:0] sum;
assign sum = DI + {CI, 1'b0} + S;

assign O = sum[3:0];
assign CO = sum[4];

endmodule