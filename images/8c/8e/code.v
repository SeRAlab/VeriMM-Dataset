module down_counter_16bit
(
  input rst,
  input clk,

  output reg [15:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      count <= 16'b0000000000000000;
    end 
	else 
	begin
      count <= count - 1;
    end
  end

endmodule