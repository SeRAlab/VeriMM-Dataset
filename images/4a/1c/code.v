module binary_counter_6bit_active_low_reset
(
  input rst,
  input clk,

  output reg [5:0] count
);

  always @(posedge clk or negedge rst) begin
    if (~rst) 
	begin
      count <= 6'b000000;
    end 
	else 
	begin
      count <= count + 1;
    end
  end

endmodule