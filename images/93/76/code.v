module top_module(
  input in,
  input [n-1:0] p_in,
  input clk,
  input rst,
  input shift_dir,
  output reg out,          // Changed to reg
  output reg [n-1:0] p_out // Changed to reg
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0;
    p_out <= 0; // Initialize p_out on reset
    out <= 0;   // Initialize out on reset
  end else begin
    if (shift_dir) begin // parallel mode
      shift_reg <= p_in;
      p_out <= shift_reg;
    end else begin // serial mode
      shift_reg <= {in, shift_reg[n-1:1]};
      out <= shift_reg[0];
    end
  end
end

endmodule