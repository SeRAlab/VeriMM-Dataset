module top_module(
    input ck2,
    output reg [1:0] s
    );always @(posedge ck2)
			s <= s +1;
	
endmodule