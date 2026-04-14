module top_module(
    input clk, // Added clk input
    input [3:0] in,
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(posedge clk) begin
    stage1_out <= in;
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

always @(posedge clk) begin
    if (stage2_out == 4'b1111) begin
        out <= 4'b0000;
    end else begin
        out <= stage2_out + 1;
    end
end

endmodule