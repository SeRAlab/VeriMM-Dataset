module up_counter_max_8 
(
  input rst,
  input clk,

  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 8'b00000000;
    end 
	
	else if (count < 8'hFF) 
	begin
      count <= count + 1;
    end
  end

endmodule