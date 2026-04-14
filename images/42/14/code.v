module top_module(
	input clk,
	input trig,
	input signed [15:0] din,
	input signed [6:0] tapWeight,
	input accClr_en,
	
	(* shreg_extract = "no" *) output reg oflowDetect = 1'd0,
	output reg signed [15:0] dout = 16'sd0);parameter IIR_scale = 15; 



(* shreg_extract = "no" *) reg signed [15:0] din_del = 16'sd0;
`ifdef ADDPIPEREG (* shreg_extract = "no" *) reg signed [15:0] din_del_b = 16'sd0;
`endif
reg signed [47:0] tap = 48'sd0;
reg signed [22:0] multreg = 23'sd0;

(* equivalent_register_removal = "no" *) reg trig_a = 1'b0, trig_b = 1'b0;
wire trig_edge = trig_a & ~trig_b;

(* shreg_extract = "no" *) reg signed [6:0] tapWeight_a = 7'sd0, tapWeight_b = 7'sd0;


wire oflow = (~&tap[47:IIR_scale+15] && ~&(~tap[47:IIR_scale+15]));


always @(posedge clk) begin
	
	tapWeight_a <= tapWeight;
	tapWeight_b <= tapWeight_a;
	trig_a <= trig;
	trig_b <= trig_a;
	din_del <= din;
	`ifdef ADDPIPEREG
		din_del_b <= din_del;
		multreg <= din_del*tapWeight_b;
		
		if (oflow) dout <= (tap[IIR_scale+16]) ? -16'sd32768 : 16'sd32767;
		else dout <= din_del_b + tap[IIR_scale+15:IIR_scale];
	`else
		multreg <= din*tapWeight_b;
		
		if (oflow) dout <= (tap[IIR_scale+16]) ? -16'sd32768 : 16'sd32767;
		else dout <= din_del + tap[IIR_scale+15:IIR_scale];
	`endif
	if (trig_edge && accClr_en) tap <= 48'sd0;
	else tap <= multreg + tap;
	
	
	
	
	
	
	
	oflowDetect <= oflow;
end

endmodule