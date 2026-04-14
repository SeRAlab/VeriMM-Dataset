module top_module(
  clk, 		
  reset, 		
  enable, 	
  in,
  complete,		
  out 		
);parameter BITS = 32;		
  parameter BITS_COUNTER = 6;	

  input clk, reset, enable;
  input [BITS-1:0] in;

  output reg complete;
  output reg out;
  reg [5:0] counter;	

  
  
  
  


  always@(posedge clk) begin

    if (reset==1) begin
      counter <= 6'b000000;
			complete <=0;
    end
    else  begin
      if(enable && ~(counter==BITS)) begin	
        out <= in[counter];
    		
          counter  <= counter + 6'b000001;
          complete <=0;	

			end
      else if (counter==BITS)begin
        complete <=1;
				counter  <=6'b000000;
      end
			else  begin
			counter <= 6'b000000;
			complete <=0;
			end



  end
end


endmodule