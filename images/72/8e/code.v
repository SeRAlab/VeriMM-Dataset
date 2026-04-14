module up_down_counter_6_with_load
(
  input rst,
  input clk,
  input enable,
  input direction,
  input load,
  input [5:0] data,

  output reg [5:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 6'b000000;
    end 
	
	else if (load) 
	begin
      count <= data;
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