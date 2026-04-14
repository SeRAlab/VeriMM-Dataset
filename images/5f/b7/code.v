module top_module(
    input [3:0] bin,
    output reg [2:0] dec
);always @(*) begin
    case(bin)
        4'b0000: dec = 3'b000;
        4'b0001: dec = 3'b001;
        4'b0010: dec = 3'b010;
        4'b0011: dec = 3'b011;
        4'b0100: dec = 3'b100;
        4'b0101: dec = 3'b101;
        4'b0110: dec = 3'b110;
        4'b0111: dec = 3'b111;
        4'b1000: dec = 3'b000;
        4'b1001: dec = 3'b001;
        4'b1010: dec = 3'b010;
        4'b1011: dec = 3'b011;
        4'b1100: dec = 3'b100;
        4'b1101: dec = 3'b101;
        4'b1110: dec = 3'b110;
        4'b1111: dec = 3'b111;
    endcase
end

endmodule