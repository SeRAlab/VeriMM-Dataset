module top_module(
    input clk,                     // Added clk input
    input [15:0] data,
    input [3:0] shift_amount,
    input direction,
    output reg [15:0] q
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @(*) begin
    if (direction == 1) begin
        stage1_out = data << shift_amount;
        stage2_out = stage1_out << shift_amount;
    end else begin
        stage1_out = data >> shift_amount;
        stage2_out = stage1_out >> shift_amount;
    end
end

always @(posedge clk) begin
    q <= stage2_out;
end

endmodule