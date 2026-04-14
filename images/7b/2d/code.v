module top_module(
  input [n-1:0] in,
  input [1:0] shift_dir,
  input [log2(s)-1:0] shift_amt,
  output reg [n-1:0] out // Changed to reg to allow assignment in always block
);parameter n = 8; // number of input and output signals
parameter s = 8; // maximum shift amount (power of 2)

// Function to calculate log2 of parameter s
function integer log2;
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

reg [n-1:0] shifted_in;

always @(*) begin
  if (shift_dir == 2'b00) // shift right
    shifted_in = {in[n-1], in[n-1], in[n-1], in[n-1], in[n-1], in[n-1], in[n-1], in[n-1]}; // fill with MSB
  else // shift left
    shifted_in = {in, {s{1'b0}}}; // fill with 0s
  
  if (shift_amt >= s) // shift amount too large
    out = {n{1'b0}}; // set output to 0
  else if (shift_amt == 0) // no shift
    out = in;
  else if (shift_dir == 2'b00) // shift right
    out = shifted_in >> shift_amt;
  else // shift left
    out = shifted_in << shift_amt;
end

endmodule