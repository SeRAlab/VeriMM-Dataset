module top_module(
    input a,
    input b,
    input sel_b1,
    input clk,            // Added clk input
    output reg out_always
);reg pipeline_reg;

always @(posedge clk) begin
    pipeline_reg <= sel_b1;
end

always @(*) begin
    if (pipeline_reg) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule