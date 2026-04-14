module lfsr_8 
(
  input rst,
  input clk,
  
  output reg [7:0] out
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      out <= 8'b00000001;
    end 
	else 
	begin
      out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]};
    end
  end

endmodule