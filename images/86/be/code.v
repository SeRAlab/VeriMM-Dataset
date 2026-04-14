module top_module(
	
   input wire clk, 
	input wire button, 
   
   output wire bounce_state
   );reg sync_to_clk0;
	reg sync_to_clk1;
		
   reg debounce_temp;
   reg [15:0] counter;

	
	always @ (posedge clk) begin
		sync_to_clk0 <= button;
		sync_to_clk1 <= sync_to_clk0;
	end
	
	
   always @ (posedge clk) begin
		if (debounce_temp == sync_to_clk1) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1'b1;
			if (counter == 20) begin
				debounce_temp <= ~bounce_state;
			end
      end
	end
	
	assign bounce_state = debounce_temp;

endmodule