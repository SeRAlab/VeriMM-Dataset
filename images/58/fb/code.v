module top_module(
    input [15:0] data,
    input [3:0] shift_amount,
    output reg [15:0] out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @(*) begin
    stage1_out = (shift_amount[3]) ? data << 8 : data;
end

always @(*) begin
    stage2_out = (shift_amount[2]) ? stage1_out << 4 : stage1_out;
end

always @(*) begin
    out = (shift_amount[1]) ? stage2_out << 2 : stage2_out;
end

endmodule