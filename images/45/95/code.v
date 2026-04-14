module top_module(
    input wire clk,          // Added clk input
    input [3:0] binary,
    output reg [3:0] hex
);reg [3:0] stage1;
reg [3:0] stage2;

always @ (posedge clk) begin
    stage1 <= binary;
    stage2 <= stage1;
    hex <= stage2;
end

endmodule