module top_module(
    input [31:0] limit,
    input clk,
    input reset,
    output reg generate_pulse,
	 output reg [31:0]generated_packets,
	 input my_reset
    );reg [31:0] counter;





always @(posedge clk)
begin

	if(reset || my_reset)
	begin
		
			counter = 0;
			generated_packets =0;
	end
	else
	begin
			if(counter == limit )
			begin
				generate_pulse =1;
				counter =0;
				generated_packets = generated_packets +1;
			end
			else if(counter > limit)
			begin
				generate_pulse =0;
				counter =0;
			end
			else if(counter <limit)
			begin
					generate_pulse=0;
			end
						counter = counter +1;
	end

end 



endmodule