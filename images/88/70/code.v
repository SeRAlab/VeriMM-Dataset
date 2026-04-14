module down_counter_enable_3 
(
  input rst,
  input clk,
  input enable,

  output reg [2:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 3'b111;
    end 
	
	else if (enable) 
	begin
      count <= count - 1;
    end
  end

endmodule