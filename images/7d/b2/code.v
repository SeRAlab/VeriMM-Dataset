module top_module(
    input [3:0] d,
    input [1:0] s,
    output reg y
    );always @ (d, s) 
	 begin         
		if (s == 2'b0) begin
			y = d[0];
		end
		else begin
			y = d[1]; 
		end
	 end
endmodule