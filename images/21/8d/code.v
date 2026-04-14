module binary_to_decimal (
    input [2:0] binary,
    output reg [3:0] decimal
);

always @(*) begin
    case(binary)
        3'b000: decimal = 4'b0000; // 0
        3'b001: decimal = 4'b0001; // 1
        3'b010: decimal = 4'b0010; // 2
        3'b011: decimal = 4'b0011; // 3
        3'b100: decimal = 4'b0100; // 4
        3'b101: decimal = 4'b0101; // 5
        3'b110: decimal = 4'b0110; // 6
        3'b111: decimal = 4'b0111; // 7
        default: decimal = 4'b0000;
    endcase
end
endmodule