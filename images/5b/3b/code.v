module top_module(
	 cin, 
	 a, 
	 b, 
	 s, 
	 cout 
    );input a, b, cin;
	 output wire s, cout;
	 
	 assign s = a ^ b ^ cin;
	 assign cout = (a & b) | (a & cin) | (b & cin);

endmodule