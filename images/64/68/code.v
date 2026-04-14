module up_down_counter_8
(
  input rst,
  input clk,
  input enable,
  input direction,

  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 8'b00000000;
    end 
	
	else if (enable) 
	begin
      if (direction) 
	  begin
        count <= count + 1;
      end 
	  
	  else 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule