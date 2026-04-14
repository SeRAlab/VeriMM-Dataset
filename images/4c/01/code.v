module top_module(
		input clk, 
		input rst,
		input ButtonIn,
		output reg ButtonOut
		
	);parameter Ncount = 20;  
	
	reg  [Ncount-1 : 0]	counter;							
	reg  [Ncount-1 : 0]	counter_next;
	
	reg state1, state2;									
	wire stop_count;											
	wire init_count;

	
	assign	init_count = ~(state1  ^ state2);
	assign 	stop_count = ~(counter[Ncount-1]);			
	

	always @ ( init_count, stop_count, counter)
		begin
			case( {init_count , stop_count})
			
				2'b10 : counter_next <= counter;						
				2'b11 : counter_next <= counter + 1;
				default : counter_next <= 0;
						
			endcase 	
		end


always @ ( posedge clk ) begin
	if(rst) begin
			state1 <= 1'b0;
			state2 <= 1'b0;
			counter <= 0;
	end else begin
			state1 <= ButtonIn;
			state2 <= state1;
			counter <= counter_next;
	end
end

	

always @ ( posedge clk )begin
	if(counter[Ncount-1])
		ButtonOut <= state2;
	else
		ButtonOut <= ButtonOut;
	end

endmodule