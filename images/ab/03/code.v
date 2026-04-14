module top_module(clk, rst_n, data_in, BCD4);input clk, rst_n;
	input [7:0] data_in;
	
	output [15:0] BCD4;
	
	reg [11:0] data;
	
	parameter T100ms = 5_000_000;		
	
	reg [25:0] cnt100ms;
	
	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					cnt100ms <= 0;
					data <= 0;
				end
			else
				begin
					if (cnt100ms < T100ms - 1)
						cnt100ms <= cnt100ms + 26'd1;
					else
						begin
							cnt100ms <= 0;
							data <= (data_in * 2500) / 256;
						end
				end
		end

	assign BCD4[ 3: 0] = data % 10;
	assign BCD4[ 7: 4] = data / 10 % 10;
	assign BCD4[11: 8] = data / 100 % 10;
	assign BCD4[15:12] = data / 1000 % 10;

endmodule