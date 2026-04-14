module top_module(
    input [3:0] D,
    input [1:0] S,
    input shift_right,
    input clk,         // Added clk input
    output reg [3:0] Q
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if (shift_right) begin
        case(S)
            2'b00: stage1_out = {2'b00, D[3:2]};
            2'b01: stage1_out = {2'b00, D[3:1]};
            2'b10: stage1_out = {2'b00, D[3]};
            2'b11: stage1_out = D;
        endcase
    end else begin
        case(S)
            2'b00: stage1_out = {D[2:0], 2'b00};
            2'b01: stage1_out = {D[1:0], D[3]};
            2'b10: stage1_out = {D[0], D[3:1]};
            2'b11: stage1_out = D;
        endcase
    end
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign Q = stage2_out;

endmodule