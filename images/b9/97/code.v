module top_module(
    data_i,
    data_o
    );input [25:0] data_i;

output [27:0] data_o;

reg [27:0] i,data_o;



always @( * )
	begin
	
	data_o[0] = 1'b0;
	data_o[1] = 1'b0;

	for(i=2; i<=27; i=i+1)
		begin
		data_o[i] = data_i[i-2];
		end
		
	end

endmodule