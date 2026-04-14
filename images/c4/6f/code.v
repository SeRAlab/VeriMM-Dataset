module calculator(
    input [7:0] A,
    input [7:0] B,
    input [1:0] opcode,
    output reg [15:0] result
);

always @* begin
    case(opcode)
        2'b00: result = A + B;
        2'b01: result = A - B;
        2'b10: result = A * B;
        2'b11: result = A / B;
    endcase
end

endmodule