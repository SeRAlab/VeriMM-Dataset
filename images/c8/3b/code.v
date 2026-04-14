module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] C
);

always @(*) begin
    if (Cin == 1'b0) begin
        C = A + B;
    end else begin
        C = A + B + 1'b1;
    end
end

endmodule