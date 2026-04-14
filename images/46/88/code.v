module top_module(clk,PC_plus_4_in,hold,IF_flush,instruc_in
                           ,instruc_out,PC_plus_4_out);input hold,IF_flush,clk;
input [31:0] instruc_in;
input wire [12:0] PC_plus_4_in;
output reg [31:0] instruc_out ;
output reg [12:0]PC_plus_4_out;


always @ (posedge clk)
	begin
	
	if(hold==1'b1)
		begin

		PC_plus_4_out <= PC_plus_4_in;
		instruc_out <= instruc_in;

		end

	else if(IF_flush==1'b1)
		begin
		
		PC_plus_4_out <= PC_plus_4_in;
		instruc_out <= 32'b0;

		end

	end


endmodule