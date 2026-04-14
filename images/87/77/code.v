module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input clk,          // Added clk input
    output reg out_always
);reg pipeline_reg1;
reg pipeline_reg2;

always @(posedge clk) begin
    pipeline_reg1 <= sel_b1;
    pipeline_reg2 <= sel_b2;
end

always @(posedge clk) begin
    if (pipeline_reg1 && pipeline_reg2) begin
        out_always <= b;
    end else begin
        out_always <= a;
    end
end

endmodule