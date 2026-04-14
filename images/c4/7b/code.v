module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input CLK,
    output reg [3:0] S,
    output reg Cout
);

reg [3:0] sum;

always @(posedge CLK) begin
    sum = A + B + Cin;
    S = sum[3:0];
    Cout = sum[4];
end

endmodule