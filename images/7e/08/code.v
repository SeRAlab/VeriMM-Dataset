module top_module(
    input [2:0] D,
    output reg [3:0] BCD
);always @(*) begin
    case(D)
        3'b000: BCD = 4'b0000;
        3'b001: BCD = 4'b0001;
        3'b010: BCD = 4'b0010;
        3'b011: BCD = 4'b0011;
        3'b100: BCD = 4'b0100;
        3'b101: BCD = 4'b0101;
        3'b110: BCD = 4'b0110;
        3'b111: BCD = 4'b0111;
    endcase
end

endmodule