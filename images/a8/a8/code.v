module top_module(
  input wire data,   
  input wire clk,    
  input wire reset,  
  output reg q       
);reg data_1delay = 1'b0;
  reg data_2delay = 1'b0;
  always @( posedge clk or negedge reset) begin
    if (~reset) begin
      data_1delay <= 1'b0;
		data_2delay <= 1'b0;
		q <= 1'b0;
    end else begin
      data_2delay <= data_1delay;
		data_1delay <= data;
		if( data_1delay == 1'b1 && data_2delay == 1'b0) begin
		  q <= 1'b1;
		end else begin
        q <= 1'b0;
      end
    end
  end  

endmodule