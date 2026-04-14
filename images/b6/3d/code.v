module down_counter_enable_8 
(
  input rst,
  input clk,
  input enable,

  output reg [7:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 8'b11111111;
    end 
	
	else if (enable) 
	begin
      count <= count - 1;
    end
  end

endmodule