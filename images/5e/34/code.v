module top_module(
    input [3:0] data_in,
    input [1:0] shift,
    input clk,  // Added clk input
    output reg [3:0] data_out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(shift)
        2'b00: stage1_out = data_in;
        2'b01: stage1_out = {data_in[2:0], 1'b0};
        2'b10: stage1_out = {1'b0, data_in[3:1]};
        2'b11: stage1_out = {2'b00, data_in[3:2]};
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out;  // Update the sequence of the assignments
    data_out <= stage2_out;
end

endmodule