module top_module(
		en,a0,a1,d0,d1,d2,d3
    );input en,a0,a1;
output d0,d1,d2,d3;

assign d0=(en&~a1&~a0);
assign d1=(en&~a1&a0);
assign d2=(en&a1&~a0);
assign d3=(en&a1&a0);

endmodule