module mux_4to1 (
    input [3:0] A, B, C, D,
    input [1:0] S,
    output reg [3:0] OUT
);

always @(*) begin
    case(S)
        2'b00: OUT = A;
        2'b01: OUT = B;
        2'b10: OUT = C;
        2'b11: OUT = D;
    endcase
end

endmodule