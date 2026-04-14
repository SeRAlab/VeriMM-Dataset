module top_module(
    input enable,
    input [1:0] select,
    input invert,
    output reg [7:0] out
);always @(*) begin
    case (select)
        2'b00: out = enable ? (invert ? 8'b11111110 : 8'b00000001) : 8'b00000000;
        2'b01: out = enable ? (invert ? 8'b11111101 : 8'b00000010) : 8'b00000000;
        2'b10: out = enable ? (invert ? 8'b11111011 : 8'b00000100) : 8'b00000000;
        2'b11: out = enable ? (invert ? 8'b11110111 : 8'b00001000) : 8'b00000000;
        default: out = 8'b00000000;
    endcase
end

endmodule