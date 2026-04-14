module up_down_counter_3 
(
  input rst,
  input clk,
  input up,
  input down,

  output reg [2:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 3'b000;
    end 
	else if (up) 
	begin
      count <= count + 1;
    end 
	else if (down) 
	begin
      count <= count - 1;
    end
  end

endmodule