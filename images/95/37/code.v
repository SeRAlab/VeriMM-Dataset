module fibonacci_lfsr_6 
(
  input rst,
  input clk,
  
  output reg [5:0] out
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      out <= 6'b000001;
    end 
	else 
	begin
      out <= {out[4:0], out[5] ^ out[3]};
    end
  end

endmodule