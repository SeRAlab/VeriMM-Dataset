module top_module(
    input clk,
    input [3:0] in,
    output reg [15:0] out
);always @(posedge clk) begin
    case (in)
        4'b0000: out <= 16'h0000;
        4'b0001: out <= 16'h1111;
        4'b0010: out <= 16'h0101;
        4'b0011: out <= 16'h1010;
        4'b0100: out <= 16'h0011;
        4'b0101: out <= 16'h1100;
        4'b0110: out <= 16'h0110;
        4'b0111: out <= 16'h1001;
        4'b1000: out <= 16'h1111;
        4'b1001: out <= 16'h0000;
        4'b1010: out <= 16'h1010;
        4'b1011: out <= 16'h0101;
        4'b1100: out <= 16'h1100;
        4'b1101: out <= 16'h0011;
        4'b1110: out <= 16'h1001;
        4'b1111: out <= 16'h0110;
        default: out <= 16'h0000;
    endcase
end

endmodule