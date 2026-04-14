module top_module(
    input [3:0] data,
    input [1:0] shift,
    input clk,         // Added the clock input
    output reg [3:0] q
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(shift)
        2'b00: stage1_out = data;
        2'b01: stage1_out = {data[0], data[3:1]};
        2'b10: stage1_out = {data[1:0], data[3:2]};
        2'b11: stage1_out = {data[2:0], data[3]};
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign q = stage2_out;

endmodule