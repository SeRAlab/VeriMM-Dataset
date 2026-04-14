module top_module(
    input [3:0] DATA,
    input [1:0] SHIFT,
    output [3:0] RESULT
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(SHIFT)
        2'b00: stage1_out = DATA;
        2'b01: stage1_out = {DATA[3], DATA[0], DATA[1], DATA[2]};
        2'b10: stage1_out = {DATA[2], DATA[3], DATA[0], DATA[1]};
        2'b11: stage1_out = {DATA[1], DATA[2], DATA[3], DATA[0]};
    endcase
end

always @(*) begin
    case(SHIFT)
        2'b00: stage2_out = stage1_out;
        2'b01: stage2_out = {stage1_out[2:0], stage1_out[3]};
        2'b10: stage2_out = {stage1_out[1:0], stage1_out[3:2]};
        2'b11: stage2_out = {stage1_out[0], stage1_out[3:1]};
    endcase
end

assign RESULT = stage2_out;

endmodule