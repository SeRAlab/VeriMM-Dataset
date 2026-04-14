module top_module(
    input clk,
    input reset,
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(posedge clk) begin
    stage1_out <= out + 1;
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

always @(posedge clk) begin
    if (reset) begin
        out <= 4'b0;
    end else begin
        out <= stage2_out;
    end
end

endmodule