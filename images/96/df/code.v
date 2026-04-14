module up_down_counter 
(
  input rst_n,
  input clk,
  input enable,
  input up_down,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b0000;
    end 
	
	else if (enable) 
	begin
      if (up_down) 
	  begin
        count <= count + 1;
      end 
	  
	  else begin
        count <= count - 1;
      end
    end 
	
	else begin
      count <= count; // Pause the count when enable is invalid
    end
  end

endmodule