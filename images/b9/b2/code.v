module top_module(
	input wire clk_in_domain,
	input wire start_in,
	input wire clk_out_domain,
	input wire start_out
    );reg input_seen = 0; 
	 
	 reg [3:0] output_buffer;
	 
	 assign start_out = output_buffer[3]^output_buffer[2];

	 always@(posedge clk_in_domain)
	 begin
	 input_seen <= start_in ? ~input_seen : input_seen;
	 end
	 
	 always@(posedge clk_out_domain)
	 begin
	 output_buffer <= {output_buffer[2:0], input_seen};
	 end


endmodule