module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] C
);

always @(*) begin
    if (A + B > 15) begin
        C = (A + B) & 4'b1111;
    end else begin
        C = A + B;
    end
end

endmodule