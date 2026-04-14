module top_module(
	input        clk,              
	input        rst_n,
	input  [7:0] PA,               
	output       event_latch       
);parameter OUT_OF_SYNC = 1'b1;
	parameter IN_SYNC     = 1'b0;

	reg [7:0]  PA_store [0:1];
	reg        sync_state = IN_SYNC;

	reg bus_latch = 0;


	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			PA_store[0] <= 8'b0; 
			PA_store[1] <= 8'b0;
			bus_latch   <= 1'b0;
			sync_state  <= IN_SYNC;
		end
		else begin
			PA_store[0] <= PA;          
			PA_store[1] <= PA_store[0]; 
			if (sync_state == IN_SYNC) begin 
				
				
				if (((PA != PA_store[0]) || (PA_store[1] != PA_store[0]))) begin
					sync_state <= OUT_OF_SYNC; 
					bus_latch <= 0;            
				end
			end else if (sync_state == OUT_OF_SYNC) begin
				bus_latch  <= 0;
				
				if ((PA == PA_store[0]) && (PA_store[1] == PA_store[0])) begin
					bus_latch <= 1;
					sync_state <= IN_SYNC;
				end
			end
		end
	end
	
	
	assign event_latch    = bus_latch;

endmodule