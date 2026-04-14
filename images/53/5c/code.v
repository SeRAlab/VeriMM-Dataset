module top_module(
    input [3:0] data,
    input [1:0] shift,
    input shift_right,
    input shift_left,
    input rotate_right,
    input rotate_left,
    input clk,  // Added clk input declaration
    output reg [3:0] result
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if (shift_right) begin
        stage1_out = {2'b00, data[3:2]};  // Shift right logic
    end else if (shift_left) begin
        stage1_out = {data[1:0], 2'b00};  // Shift left logic
    end else if (rotate_right) begin
        stage1_out = {data[0], data[3:1]};  // Rotate right logic
    end else if (rotate_left) begin
        stage1_out = {data[2:0], data[3]};  // Rotate left logic
    end else begin
        stage1_out = data;  // Default case: no shift/rotate
    end
end

always @(posedge clk) begin
    stage2_out <= stage1_out;  // Capture the output stage
end

assign result = stage2_out;  // Assign the final result

endmodule