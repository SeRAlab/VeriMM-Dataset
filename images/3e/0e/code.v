module QAM16_Modulator (
    input [3:0] symbol,
    output reg [1:0] I,
    output reg [1:0] Q
);
always @(*) begin
    case (symbol)
        4'b0000: {I, Q} = 4'b11; // 1 + j1
        4'b0001: {I, Q} = 4'b10; // 1 - j1
        4'b0010: {I, Q} = 4'b01; // -1 + j1
        4'b0011: {I, Q} = 4'b00; // -1 - j1
        4'b0100: {I, Q} = 4'b11; // 1 + j1
        4'b0101: {I, Q} = 4'b10; // 1 - j1
        4'b0110: {I, Q} = 4'b01; // -1 + j1
        4'b0111: {I, Q} = 4'b00; // -1 - j1
        4'b1000: {I, Q} = 4'b11; // 1 + j1
        4'b1001: {I, Q} = 4'b10; // 1 - j1
        4'b1010: {I, Q} = 4'b01; // -1 + j1
        4'b1011: {I, Q} = 4'b00; // -1 - j1
        4'b1100: {I, Q} = 4'b11; // 1 + j1
        4'b1101: {I, Q} = 4'b10; // 1 - j1
        4'b1110: {I, Q} = 4'b01; // -1 + j1
        4'b1111: {I, Q} = 4'b00; // -1 - j1
        default: {I, Q} = 4'b00; // Default case
    endcase
end
endmodule