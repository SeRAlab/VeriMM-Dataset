module top_module(
			input signed [20:0] charge_in,
			input signed [16:0] signal_in,
			input delay_en,
			input clk,
			input store_strb,
			input fb_en,
			output reg signed [14:0] pout,
			input bunch_strb,
			output reg DSPoflow,

			output reg fb_cond,
			output reg dac_clk
			

		
    );(* equivalent_register_removal = "no"*) reg [7:0] j;

reg signed [37:0]  DSPtemp;

reg signed [14:0] delayed; 

reg signed [37:0] DSPout;


reg signed [20:0] chargeA = 21'd0;

always @ (posedge clk) begin
chargeA <= charge_in;
DSPtemp <= chargeA*signal_in;

DSPout <= DSPtemp+{delayed, 12'b0}; 
pout<=DSPout[26:12];
DSPoflow<=(~&DSPout[37:26] && ~&(~DSPout[37:26]));
end




always @ (posedge clk) begin
if (~store_strb) begin
j<=8;       
 end
else if (bunch_strb) begin j<=0;

end
else if (~bunch_strb) begin
j<=j+1;
end

end







reg [14:0] delayed_a;
always @ (posedge clk) begin
delayed<=delayed_a; 
if (~store_strb) begin
delayed_a<=0;
end
else if (delay_en==1) begin
if (j==6) delayed_a<=pout;
end
end




always @ (posedge clk) begin
if (fb_en) begin
if (j==2||j==3) fb_cond<=1;
else fb_cond<=0;
end
else fb_cond<=0;
end


(* equivalent_register_removal = "no"*) reg delay_store_strb;
reg clr_dac;
reg delay_clr_dac;


always @ (posedge clk) begin
if (fb_en) begin
if (j==6||j==7||clr_dac==1||delay_clr_dac==1) dac_clk<=1;
else dac_clk<=0;
end
else dac_clk<=0;
end



always @(posedge clk) begin
delay_store_strb<=store_strb;
delay_clr_dac<=clr_dac;
if ((delay_store_strb==1)&(store_strb==0)) clr_dac<=1;
else clr_dac<=0;
end

endmodule