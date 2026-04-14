module top_module(
    input [7:0] data_in,
    input [2:0] shift_amount,
    input direction_left,
    input clk,                     // Added clk input
    output reg [7:0] data_out
);reg [7:0] pipeline_reg1;
reg [7:0] pipeline_reg2;
reg [7:0] pipeline_reg3;

always @(*) begin
    pipeline_reg1 = data_in;
end

always @(posedge clk) begin
    pipeline_reg2 <= pipeline_reg1; // Changed = to <= for non-blocking assignment
end

always @(posedge clk) begin
    pipeline_reg3 <= pipeline_reg2; // Changed = to <= for non-blocking assignment
end

always @(posedge clk) begin
    if (shift_amount == 0) begin
        data_out <= pipeline_reg3;
    end else if (direction_left == 1) begin
        data_out <= pipeline_reg3 << shift_amount;
    end else begin
        data_out <= pipeline_reg3 >> shift_amount;
    end
end

endmodule