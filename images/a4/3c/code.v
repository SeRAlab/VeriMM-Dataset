module top_module(
		input [1:0]Rx,
		input clk, 
		input reset,
		input [1:0] identidad, 
		output reg bandera
    );always@(posedge clk, posedge reset)
	 	begin
			if (reset)
				bandera<=0;
			else 
				if(identidad == Rx)
					bandera<=1;
				else
					bandera<=0;
		end


endmodule