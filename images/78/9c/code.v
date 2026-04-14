module lfsr_5 
(
  input rst,
  input clk,
  input enable,

  output reg [4:0] lfsr_out
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      lfsr_out <= 5'b10011; // Seed value
    end 
	
	else if (enable) 
	begin
      lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
    end 
	
	else begin
      lfsr_out <= lfsr_out; // Pause the shift when enable is low
    end
  end

endmodule