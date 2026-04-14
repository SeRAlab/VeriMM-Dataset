module top_module(
	input	clk,
	input rst,
	output [15:0] out_par,
	output	out_ser
    );reg [15:0] reg_data;
	reg in_data;
	reg out_data;
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			reg_data <= 16'h1234;
			in_data <= 1'b0;
			out_data <= reg_data[15];
		end
		else
		begin
			in_data <= (reg_data[15] ^ (reg_data[13] ^ (reg_data[12] ^ reg_data[10])));
			out_data <= reg_data[15];
			reg_data <= {reg_data[14:0], in_data};
		end
	end
	
	assign out_par = reg_data;
	assign out_ser = out_data;
	

endmodule