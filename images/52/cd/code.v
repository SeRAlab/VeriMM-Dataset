module up_down_counter_6 
(
  input rst,
  input clk,
  input direction,

  output reg [5:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 6'b000000;
    end 
	
	else 
	begin
      if (direction) 
	  begin
        count <= count - 1;
      end 
	  
	  else 
	  begin
        count <= count + 1;
      end
    end
  end

endmodule