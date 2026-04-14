module top_module(
    input clk,                 // Added input for the clock signal
    input [3:0] binary1,
    input [3:0] binary2,
    output reg [3:0] sum
);reg [3:0] stage1_sum;
reg [3:0] stage2_sum;

always @ (posedge clk) begin
    stage1_sum <= binary1 + binary2;
end

always @ (posedge clk) begin
    stage2_sum <= stage1_sum;
end

always @ (posedge clk) begin
    sum <= stage2_sum;
end

endmodule