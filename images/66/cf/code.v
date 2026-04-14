module top_module(
    input clk,
    input rst,
    input signed [3:0] data_in,
    input [1:0] shift_amount,
    output reg signed [3:0] data_out
);reg signed [3:0] stage1_out;
reg signed [3:0] stage2_out;

always @(posedge clk) begin
    if (rst) begin
        data_out <= 4'b0;
        stage1_out <= 4'b0;
        stage2_out <= 4'b0;
    end else begin
        stage1_out <= data_in << shift_amount;
        stage2_out <= (shift_amount[1]) ? {2{stage1_out[3]}} : {2'b0, stage1_out[3:2]};
        data_out <= (shift_amount[0]) ? stage2_out >> 1 : stage2_out;
    end
end

endmodule