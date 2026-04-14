module modulo_10_counter 
(
  input rst_n,
  input clk,
  input enable,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b0000;
    end 
	
	else if (enable) 
	begin
      if (count == 4'd9) 
	  begin
        count <= 4'b0000;
      end 
	  
	  else 
	  begin
        count <= count + 1;
      end
    end 
	
	else begin
      count <= count; // Pause the count when enable is low
    end
  end

endmodule