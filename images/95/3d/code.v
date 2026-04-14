module top_module(
	input clk,
	input reset,
	input hilo_w_en_1,
	input hilo_w_en_2,
	input [31:0] hilo_w_data_1,
	input [31:0] hilo_w_data_2,
	output [31:0] hilo_r_data
    );reg [31:0] Register;
	assign hilo_r_data=Register;
	
	always @(negedge clk or negedge reset)
	begin
		if(reset==0)
			Register <= 32'b0;
		else if(hilo_w_en_2)
		begin
			Register<= hilo_w_data_2;
		end
		else if(hilo_w_en_1)
		begin
			Register<= hilo_w_data_1;
		end
	end
	
	
	
		
		
			
		
	
	

endmodule