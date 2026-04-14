module top_module(
    input [3:0] in,
    input clk,            // Added clk as an input
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out = in + 1;
end

always @(*) begin
    if (stage1_out == 4'b1111) begin
        stage2_out = 4'b0000;
    end else begin
        stage2_out = stage1_out;
    end
end

always @(posedge clk) begin
    out <= stage2_out;
end

endmodule