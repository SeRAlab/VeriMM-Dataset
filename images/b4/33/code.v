module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  output reg [m-1:0] out // Changed from wire to reg
);parameter n = 4; // number of input samples
parameter m = 2; // number of output samples
parameter k = 3; // number of filter coefficients

reg [n-1:0] shift_reg [0:n-1]; // Corrected to make it an array
reg [m-1:0] output_reg;
reg [k-1:0] coeff_mem [0:k-1];

integer i, j;

initial begin
  // Initialize output register
  output_reg = 0;
  
  // Initialize filter coefficients
  coeff_mem[0] = 1;
  coeff_mem[1] = 2;
  coeff_mem[2] = 1;
end

always @(posedge clk) begin
  if (rst) begin
    // Reset shift register and output register to zero
    for (i = 0; i < n; i = i + 1) begin
      shift_reg[i] <= 0;
    end
    output_reg <= 0;
  end else begin
    // Shift in new input sample and shift out oldest input sample
    for (i = n-1; i > 0; i = i - 1) begin
      shift_reg[i] <= shift_reg[i-1];
    end
    shift_reg[0] <= in;
    
    // Compute weighted sum of previous k input samples using filter coefficients
    output_reg = 0;
    for (j = 0; j < k; j = j + 1) begin
      output_reg = output_reg + (shift_reg[j] * coeff_mem[j]);
    end
    
    // Output result of weighted sum as current output sample
    out <= output_reg; // No changes needed here
  end
end

endmodule