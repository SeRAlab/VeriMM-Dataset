module lfsr_12 
(
  input rst,
  input clk,

  output reg [11:0] lfsr_out
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      lfsr_out <= 12'b000000000001;
    end 
	
	else 
	begin
      lfsr_out <= {lfsr_out[10:0], lfsr_out[11] ^ lfsr_out[10]};
    end
  end

endmodule