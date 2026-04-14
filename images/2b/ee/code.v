module power_gating(
    input wire enable,
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [4:0] sum
);
    assign sum = enable ? (A + B) : 5'b0;
endmodule