module top_module(
    input [15:0] DATA,
    input [3:0] SHIFT,
    input [1:0] CTRL,
    output reg [15:0] out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @(*) begin
    case (CTRL)
        2'b00: stage1_out = DATA << SHIFT; // Logical left shift
        2'b01: stage1_out = DATA >> SHIFT; // Logical right shift
        2'b10: stage1_out = $signed(DATA) >>> SHIFT; // Arithmetic right shift
        2'b11: stage1_out = DATA; // No shift
        default: stage1_out = DATA; // Fallback
    endcase
end

always @(*) begin
    case (CTRL)
        2'b00: stage2_out = stage1_out << SHIFT; // Logical left shift
        2'b01: stage2_out = stage1_out >> SHIFT; // Logical right shift
        2'b10: stage2_out = $signed(stage1_out) >>> SHIFT; // Arithmetic right shift
        2'b11: stage2_out = stage1_out; // No shift
        default: stage2_out = stage1_out; // Fallback
    endcase
end

assign out = stage2_out;

endmodule