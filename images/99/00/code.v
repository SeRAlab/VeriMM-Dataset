module verified_lfsr_16 
(
  input rst_n,
  input clk,

  output reg [15:0] lfsr_out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      lfsr_out <= 16'b1111111111111111;
    end 

	else 
	begin
      lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};
    end
  end

endmodule