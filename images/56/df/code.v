module top_module(
    input [3:0] BIN,
    output reg [3:0] BCD_HI,
    output reg [3:0] BCD_LO
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out = BIN + 6'd30;
end

always @(*) begin
    stage2_out = stage1_out + (stage1_out >= 5'd10 ? 3'd6 : 3'd0);
end

assign BCD_HI = stage2_out[3:2];
assign BCD_LO = stage2_out[1:0];

endmodule