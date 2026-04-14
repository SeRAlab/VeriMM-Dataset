module top_module(
    input [3:0] B,
    output reg [3:0] E
);always @(*) begin
    case (B)
        4'b0000: E = 4'b0011;
        4'b0001: E = 4'b0100;
        4'b0010: E = 4'b0101;
        4'b0011: E = 4'b0110;
        4'b0100: E = 4'b0111;
        4'b0101: E = 4'b1000;
        4'b0110: E = 4'b1001;
        4'b0111: E = 4'b1010;
        4'b1000: E = 4'b1011;
        4'b1001: E = 4'b1100;
        4'b1010: E = 4'b1101;
        4'b1011: E = 4'b1110;
        4'b1100: E = 4'b1111;
        4'b1101: E = 4'b0000;
        4'b1110: E = 4'b0001;
        4'b1111: E = 4'b0010;
        default: E = 4'b0000;
    endcase
end

endmodule