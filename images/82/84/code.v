module top_module(
    input [15:0] input1,
    input [15:0] input2,
    input clk,            // Added the clk input
    output equal,
    output greater_than
);reg [15:0] reg_input1;
reg [15:0] reg_input2;
reg [15:0] reg_input1_delay;
reg [15:0] reg_input2_delay;
reg equal_delay;
reg greater_than_delay;

assign equal = equal_delay;
assign greater_than = greater_than_delay;

always @(posedge clk) begin
    reg_input1 <= input1;
    reg_input2 <= input2;
end

always @(posedge clk) begin
    reg_input1_delay <= reg_input1;
    reg_input2_delay <= reg_input2;
end

always @(posedge clk) begin
    if (reg_input1_delay == reg_input2_delay) begin
        equal_delay <= 1'b1;
    end else begin
        equal_delay <= 1'b0;
    end
end

always @(posedge clk) begin
    if (reg_input1_delay > reg_input2_delay) begin
        greater_than_delay <= 1'b1;
    end else begin
        greater_than_delay <= 1'b0;
    end
end

endmodule