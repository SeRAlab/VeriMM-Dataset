module top_module(
    input [3:0] ABCD,
    input clk,                // Added clk input
    output reg [1:0] XY
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

always @(*) begin
    case(ABCD)
        4'b0001: stage1_out = 2'b00;
        4'b0010: stage1_out = 2'b01;
        4'b0100: stage1_out = 2'b10;
        4'b1000: stage1_out = 2'b11;
        default: stage1_out = 2'b00;
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign XY = stage2_out;

endmodule