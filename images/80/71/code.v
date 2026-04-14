module top_module(
	input clk,
	input rst,
	input transferstart_one,
	input rd_dma_done_one,
	input new_des_one,
	output reg [23:0] round_trip_latency,
	output reg [23:0] transfer_duration
    );reg [39:0] counter;    
	 reg [23:0] snapshot_transferstart;   

    
    always@(posedge clk) begin
	    if(rst)
		    counter <= 40'h00_0000_0000;
		 else
		    counter <= counter + 40'h00_0000_0001;
	 end
	 
	 
	 always@(posedge clk) begin
	    if(rst)
		    snapshot_transferstart <= 24'h00_0000;
		 else if (transferstart_one)
		    snapshot_transferstart <= counter[23:0];
		 else
		    snapshot_transferstart <= snapshot_transferstart;
	 end
	 
	 
	 always@(posedge clk) begin
	    if (rst)
		    round_trip_latency <= 24'h00_0000;
		 else if (new_des_one)
		    round_trip_latency <= counter[23:0] + (~snapshot_transferstart) + 24'h00_0001;
		 else
		    round_trip_latency <= round_trip_latency;
	 end
	 
	 
	 always@(posedge clk) begin
	    if (rst)
		    transfer_duration <= 24'h00_0000;
		 else if (rd_dma_done_one)
		    transfer_duration <= counter[23:0] + (~snapshot_transferstart) + 24'h00_0001;
		 else
		    transfer_duration <= transfer_duration;
	 end

endmodule