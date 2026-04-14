module gray_counter 
(
  input rst_n,
  input clk,

  output reg [2:0] out
);

  reg [2:0] binary_count;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      binary_count <= 3'b000;
      out <= 3'b000;
    end 
	
	else 
	begin
      binary_count <= binary_count + 1;
      out <= {binary_count[2], binary_count[2] ^ binary_count[1], binary_count[1] ^ binary_count[0]};
    end
  end

endmodule