module top_module(
    input [2:0] bin,
    output reg [3:0] bcd);always @(*) begin
    case (bin)
        3'b000: bcd = 4'b0000; // 0
        3'b001: bcd = 4'b0001; // 1
        3'b010: bcd = 4'b0010; // 2
        3'b011: bcd = 4'b0011; // 3
        3'b100: bcd = 4'b0100; // 4
        3'b101: bcd = 4'b0101; // 5
        3'b110: bcd = 4'b0110; // 6
        3'b111: bcd = 4'b0111; // 7
        default: bcd = 4'b0000;
    endcase
end
endmodule