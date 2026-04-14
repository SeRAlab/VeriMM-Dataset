module top_module(
    input [3:0] binary,
    output reg [3:0] ones_comp,
    input clk  // Added the clk input
);reg [3:0] stage1;
reg [3:0] stage2;

always @ (posedge clk) begin
    stage1 <= ~binary;
end

always @ (posedge clk) begin
    stage2 <= stage1;
end

always @ (posedge clk) begin
    ones_comp <= stage2;  // Updated to register assignment inside clk context
end

endmodule