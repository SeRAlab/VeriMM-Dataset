module top_module(

	clock,   

	vol_in,  
	dat_in,  

	load,    
	clr_sum, 

	ready,   
	sum_out  
);input clock;

	input [5:0] vol_in;
	input [7:0] dat_in;

	input load;
	input clr_sum;

	output reg ready;

	output reg [15:0] sum_out;



	wire [5:0] add_data;
	wire [6:0] sum_unreg;
	reg [6:0] sum_reg;
	reg [7:0] shifter;
	reg [5:0] adder;
	wire   mul_out;



	reg [3:0] counter;


	reg clr_sum_reg;
	wire [1:0] temp_sum;
	wire carry_in;
	wire old_data_in;
	reg old_carry;




	
	
	always @(posedge clock)
	begin

		if( load )
			ready <= 1'b0;

		if( counter[3:0] == 4'd15 )
			ready <= 1'b1;

		if( load )
			counter <= 4'd0;
		else
			counter <= counter + 4'd1;

	end



	
	
	assign add_data = ( shifter[0] ) ? adder : 6'd0; 

	assign sum_unreg[6:0] = sum_reg[6:1] + add_data[5:0]; 

	assign mul_out = sum_unreg[0];

	always @(posedge clock)
	begin

		if( !load ) 
		begin
			sum_reg[6:0] <= sum_unreg[6:0];
			shifter[6:0] <= shifter[7:1];
		end

		else 

		begin
			sum_reg[6:0] <= 7'd0;

			shifter[7]   <= ~dat_in[7];   
			shifter[6:0] <=  dat_in[6:0];

			adder <= vol_in;

		end
	end




	
	
	always @(posedge clock)
	begin
		if( load )
			clr_sum_reg <= clr_sum;
	end

	assign carry_in = (counter==4'd0) ? 1'b0 : old_carry;

	assign old_data_in = (clr_sum_reg) ? 1'b0 : sum_out[0];

	assign temp_sum[1:0] = carry_in + mul_out + old_data_in;

	always @(posedge clock)
	begin
		if( !ready )
		begin
			sum_out[15:0] <= { temp_sum[0], sum_out[15:1] };
			old_carry <= temp_sum[1];
		end
	end



endmodule