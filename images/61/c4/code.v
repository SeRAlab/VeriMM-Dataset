module up_counter_32_sync_reset
(
  input rst,
  input clk,

  output reg [31:0] count
);

  always @(posedge clk) begin
    if (rst) 
	begin
      count <= 32'b00000000000000000000000000000000;
    end 
	else 
	begin
      count <= count + 1;
    end
  end

endmodule