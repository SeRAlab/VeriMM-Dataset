module top_module(
    input [31:0] IR,
    input [31:0] PC4,
    input [31:0] AO,
    input [31:0] RT,
    input [31:0] SH,
    output [31:0] IR_M,
    output [31:0] PC4_M,
    output [31:0] AO_M,
    output [31:0] RT_M,
    output [31:0] SH_M,
    input Clk,
	input Reset
    );reg [31:0] _IR, _PC4, _AO, _RT, _SH;
	assign IR_M = _IR;
	assign PC4_M = _PC4;
	assign AO_M = _AO;
	assign RT_M = _RT;
	assign SH_M = _SH;
	
	always @ (posedge Clk)begin
		if (Reset) begin
			_IR <= 0;
			_PC4 <= 0;
			_AO <= 0;
			_RT <= 0;
			_SH <= 0;
        end
		else begin
			_IR <= IR;
			_PC4 <= PC4;
			_AO <= AO;
			_RT <= RT;
			_SH <= SH;
		end
	end
	
endmodule