module top_module(
    input [3:0] binary,
    output reg [3:0] bcd
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out = binary + 4'b0011;
end

always @(*) begin
    stage2_out = stage1_out + (stage1_out >= 5'b1010 ? 2 : 0);
end

always @(*) begin
    bcd = stage2_out + (stage2_out >= 10 ? 4 : 0);
end

endmodule