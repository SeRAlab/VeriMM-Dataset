module top_module(reqin1, reqin2, reqout1, reqout2);input reqin1;
input reqin2;

output reqout1 ;
output reqout2 ;

wire o1 ;
wire o2 ;

assign o1 = ~(reqin1 & o2);
assign o2 = ~(reqin2 & o1);

assign reqout1 = ~o1 & o2;
assign reqout2 = ~o2 & o1;

endmodule