module top_module(
    input a, 
    input b,
    input clk,   // Added clk input
    input reset,
    output reg out
);reg stage1_out, stage2_out;

always @(posedge clk) begin
    if(reset) begin
        stage1_out <= 1'b0;
        stage2_out <= 1'b0;
        out <= 1'b0;
    end
    else begin
        stage1_out <= a | b;
        stage2_out <= stage1_out;
        out <= stage2_out;
    end
end

endmodule