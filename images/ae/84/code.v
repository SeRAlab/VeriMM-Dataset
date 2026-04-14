module top_module(
    input clk,
    input [7:0] data_in,
    input [2:0] shift_amount,
    output reg [7:0] data_out
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

always @ (posedge clk) begin
    stage1_out <= data_in >> shift_amount;
end

always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

always @ (posedge clk) begin
    data_out <= stage2_out;
end

endmodule