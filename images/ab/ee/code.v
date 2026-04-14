module top_module(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);genvar i;
	generate
		for(i=0; i<32; i=i+1)
		begin:genblock
			always @(posedge clk) begin
			    if(wrenable) begin
			        q[i] <= d[i];
			    end
			end
		end
	endgenerate
endmodule