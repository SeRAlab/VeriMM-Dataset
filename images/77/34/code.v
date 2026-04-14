module top_module(
	input 			 Clk,
	input 			 Ack,
	
	input 	  [7:0]DataIn,
	
	input 	  [7:0]key,
	
	output reg [7:0]DataOut,
	output reg      Ready	
									
);reg [3:0]count;



always @(posedge Clk) begin

	if (Ack) begin
		Ready <= 1'b0;


	end
	else begin












		DataOut <= DataIn ^ key;
			Ready <= 1'b1;				
	end
end

endmodule