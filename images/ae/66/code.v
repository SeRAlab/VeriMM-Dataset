module top_module(
	input clk,
	input reset,
	input signal,
	input [7:0] data_rx,
	output reg [7:0] data_out);reg[5:0] w_counter;
	integer i;
	parameter m=0;
	parameter n=0;


	reg [511:0] memory_ram_d [63:0];
	reg [511:0] memory_ram_q [63:0];



	always @(posedge clk or negedge reset) begin
    if (!reset) begin
        for (i=0;i<64; i=i+1)
            memory_ram_q[i] <= 0;end
    else begin
        for (i=0;i<64; i=i+1)
             memory_ram_q[i] <= memory_ram_d[i];end
	end
	always @(*) begin
		if (signal) begin
			for (i=0;i<64; i=i+1) begin
				memory_ram_d[i] = memory_ram_q[i];
				if (w_counter <= 63) begin
					memory_ram_d[i] = {memory_ram_d[i],data_rx};
					w_counter <= w_counter + 1'b1; end
				else if (w_counter >63) begin
					memory_ram_d[i+1] = {memory_ram_d[i+1],data_rx};
					w_counter <= w_counter + 1'b1; end
			end
	   end
	end
	always @ (*) begin
	     data_out <= memory_ram_q[m][n+7:n];
	end
endmodule