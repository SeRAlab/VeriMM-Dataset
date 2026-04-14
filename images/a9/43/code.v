module top_module(input signed [20:0] charge_in,input signed [14:0] signal_in,input delay_en,input clk,input store_strb,output reg signed [12:0] pout,input bunch_strb,input signed [12:0] banana_corr,output reg fb_cond);(* equivalent_register_removal = "no"*) reg [7:0] j; 
 reg signed [36:0] DSPtemp; 
 reg signed [12:0] DSPtemp2; 
 reg signed [12:0] delayed =0; 
 reg signed [36:0] DSPout; 
 always @ (posedge clk) begin 
 DSPtemp <= charge_in*signal_in; 
 DSPout <= DSPtemp+{delayed, 12'b0}; 
 pout<=DSPout[24:12]; 
 end 
 always @ (posedge clk) begin 
 if (~store_strb) begin 
 j<=7; 
  end 
 else if (bunch_strb) begin j<=0; 
 end 
 else if (~bunch_strb) begin 
 j<=j+1; 
 end 
 end 
 reg [12:0] delayed_a; 
 always @ (posedge clk) begin 
 delayed<=delayed_a; 
 if (~store_strb) begin 
 delayed_a<=0; 
 end 
 else if (delay_en==1) begin 
 if (j==5) delayed_a<=pout+banana_corr[12:2]; 
 end 
 end 
 always @ (posedge clk) begin 
 if (j==3||j==4) fb_cond<=1; 
 else fb_cond<=0; 
 end 
 endmodule