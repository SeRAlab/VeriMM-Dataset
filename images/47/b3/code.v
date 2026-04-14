module up_counter_enable_4 
(
  input rst,
  input clk,
  input enable,

  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 4'b0000;
    end 
	
	else if (enable) 
	begin
      count <= count + 1;
    end
  end

endmodule