module top_module(
    input clk,
	 input [1:0] oflowMode,
    input signed [15:0] mixerIn,
    input signed [6:0] gain,
    output reg signed [15:0] dout = 16'sd0,
    output reg overflow = 1'b0
    );parameter GAIN_SCALE = 1; 
parameter GAIN_OFFSET = 5; 
parameter GAIN_MSB = 23;

(* shreg_extract = "no" *) reg signed [15:0] mixerIn_reg = 16'sd0; 
(* shreg_extract = "no" *) reg signed [6:0] gain_reg = 7'sd0, gain_reg_b = 7'sd0; 


reg signed [GAIN_MSB:0] gainMult = 24'sd0;


wire oflowDet = (~&gainMult[GAIN_MSB:GAIN_OFFSET+GAIN_SCALE+15] && ~&(~gainMult[GAIN_MSB:GAIN_OFFSET+GAIN_SCALE+15]));

always @(posedge clk) begin
	mixerIn_reg <= mixerIn;
	gain_reg <= gain;
	gain_reg_b <= gain_reg;
	gainMult <= (mixerIn_reg * gain_reg_b);
	overflow <= oflowDet;
	if (oflowDet) begin
		case (oflowMode)
		2'b00: dout <= gainMult[GAIN_OFFSET+GAIN_SCALE+15:GAIN_OFFSET+GAIN_SCALE]; 
		2'b01: dout <= 16'sd0; 
		2'b10: dout <= (gainMult[GAIN_MSB]) ? -16'sd32768 : 16'sd32767; 
		default: dout <= 16'sd0;
		endcase 
	end else dout <= gainMult[GAIN_OFFSET+GAIN_SCALE+15:GAIN_OFFSET+GAIN_SCALE];
end

endmodule