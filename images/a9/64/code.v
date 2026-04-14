module up_down_counter_10
(
  input rst,
  input clk,
  input up,
  input down,

  output reg [9:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 10'b0000000000;
    end 
	else 
	begin
      if (up) 
	  begin
        count <= count + 1;
      end 
	  else if (down) 
	  begin
        count <= count - 1;
      end
    end
  end

endmodule