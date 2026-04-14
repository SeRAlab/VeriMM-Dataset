module adder(
    input [15:0] a,
    output reg [23:0] sum
);

initial begin
    sum = 24'b0;
end

always @(*) begin
    sum[23:16] = a[15:8] + sum[23:16];
end

endmodule