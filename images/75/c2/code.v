module top_module(
    input clk,
    input rst_n,
    input en,
    input [3:0] in,
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_out <= 4'b0000;
        stage2_out <= 4'b0000;
        out <= 4'b0000;
    end else if (en) begin
        stage1_out <= ~in + 4'b0001;
        stage2_out <= stage1_out;
        out <= stage2_out;
    end
end

endmodule