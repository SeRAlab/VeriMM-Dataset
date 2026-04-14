module top_module(
input	[63:0]		sec_data_in,	
input	[31:0]		nanosec_data_in,
input				pps_in, 		
input				clk_in, 		
input				cnt_ena_in, 	
input				pps_bypass_in,	
input				clr_n_in, 		
input				load_sec_in,	
input				load_nanosec_in,
output	[63:0]		sec_data_out,	
output	[31:0]		nanosec_data_out
);reg		[63:0]		seconds;						
reg		[31:0]		nanoseconds;					
reg					load_sec_l, load_sec_p;			
reg					load_nanosec_l, load_nanosec_p;	
wire				nano_counter_carry;				
reg					nano_counter_clr;

parameter SYSCLK_FREQ = 32'd100_000_000; 


assign	nano_counter_carry = (nanoseconds < SYSCLK_FREQ - 1) ? 1'b0:1'b1;

always @ (posedge clk_in or negedge clr_n_in)
begin
	if (!clr_n_in) begin
		nano_counter_clr <= 0;
	end
	else begin
		nano_counter_clr <= !(nano_counter_carry);
	end
end

assign sec_data_out = seconds;
assign nanosec_data_out = nanoseconds;


always @ (posedge clk_in or negedge clr_n_in)
begin
	if (!clr_n_in) begin
		load_sec_l <= 0;
		load_sec_p <= 0;
		load_nanosec_l <= 0;
		load_nanosec_p <= 0;
	end
	else begin
		load_sec_l <= load_sec_p;
		load_sec_p <= load_sec_in;
		load_nanosec_l <= load_nanosec_p;
		load_nanosec_p <= load_nanosec_in;
	end
end


always @ (posedge clk_in or negedge nano_counter_clr)
begin
	if (!nano_counter_clr) begin
		nanoseconds <= 32'b0;
	end
	else if (!cnt_ena_in) begin	
		nanoseconds <= nanoseconds;
	end
	else if ((load_nanosec_l == 0) && (load_nanosec_p == 1)) begin	
		nanoseconds <= nanosec_data_in;
	end
	else begin
		nanoseconds <= nanoseconds + 1'b1;
	end
end


always @ (posedge pps_in or negedge clr_n_in)
begin
	if (!clr_n_in) begin
		seconds <= 0;
	end
	else if (!cnt_ena_in) begin
		seconds <= seconds;
	end
	else if ((load_sec_l == 0) && (load_sec_p == 1)) begin
		seconds <= sec_data_in;
	end
	else begin
		seconds <= seconds + 1'b1;
	end
end

endmodule