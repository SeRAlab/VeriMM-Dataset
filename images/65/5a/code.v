module priority_encoder(
	input [3:0] in,
	output reg [1:0] out);always @(*) begin
    casez (in)
        4'b1000: out = 2'b11;
        4'b?100: out = 2'b10;
        4'b??10: out = 2'b01;
        4'b???1: out = 2'b00;
        default: out = 2'b00;
    endcase
end
endmodule