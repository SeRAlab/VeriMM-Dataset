module top_module(
    input [3:0] in,
    input clk,              // Added clk input
    output reg [15:0] out
);reg [3:0] in_reg;
reg [15:0] out_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    case(in_reg)
        4'b0000: out_reg <= 16'b0000000000000001; // Ensure 4'b0000 is defined
        4'b0001: out_reg <= 16'b0000000000000001;
        4'b0010: out_reg <= 16'b0000000000000010;
        4'b0011: out_reg <= 16'b0000000000000100;
        4'b0100: out_reg <= 16'b0000000000001000;
        4'b0101: out_reg <= 16'b0000000000010000;
        4'b0110: out_reg <= 16'b0000000000100000;
        4'b0111: out_reg <= 16'b0000000001000000;
        4'b1000: out_reg <= 16'b0000000010000000;
        4'b1001: out_reg <= 16'b0000000100000000;
        4'b1010: out_reg <= 16'b0000001000000000;
        4'b1011: out_reg <= 16'b0000010000000000;
        4'b1100: out_reg <= 16'b0000100000000000;
        4'b1101: out_reg <= 16'b0001000000000000;
        4'b1110: out_reg <= 16'b0010000000000000;
        4'b1111: out_reg <= 16'b0100000000000000;
        default: out_reg <= 16'b0000000000000000;
    endcase
end

always @(posedge clk) begin
    out <= out_reg;
end

endmodule