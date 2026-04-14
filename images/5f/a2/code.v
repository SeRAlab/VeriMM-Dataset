module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input clk,               // Added clk input
    output reg out_always
);reg [1:0] stage1_sel;
reg [1:0] stage2_sel;

always @(posedge clk) begin
    stage1_sel <= {sel_b2, sel_b1};
    stage2_sel <= stage1_sel;
end

always @(posedge clk) begin
    if (stage2_sel == 2'b10) begin
        out_always <= a;
    end else if (stage2_sel == 2'b01) begin
        out_always <= b;
    end else begin
        out_always <= b; // This could be a default case; consider checking for other conditions if necessary
    end
end

endmodule