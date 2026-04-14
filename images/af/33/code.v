module fibonacci_lfsr_4 
(
  input rst,
  input clk,

  output reg [3:0] lfsr
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      lfsr <= 4'b0001;
    end 
	else 
	begin
      lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
    end
  end

endmodule