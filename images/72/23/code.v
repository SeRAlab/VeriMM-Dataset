module top_module(
	 input [7:0] data_in,
	 input clk,shift,load,reset,
    output reg out
    );reg [7:0] temp = 8'd0;
	 
	 always @(posedge clk , negedge reset)
		begin
			if(!reset)
				begin
					temp <= 8'b0;
					out <= 1'b0;
				end
			else if(load)
				begin
					temp <= data_in;
				end
			else if(shift)
				begin
					temp <= {temp[6:0] , 1'b0};
					out <= temp[7];
				end
			else
				temp <= temp;
		end


endmodule