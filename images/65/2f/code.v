module top_module(
  input [n-1:0] in,
  input parity_mode,
  output out,
  output err
);parameter n = 8; // number of input bits
parameter parity = 0; // parity mode (0=even, 1=odd)

// add any additional parameters if needed

// add any additional inputs and outputs if needed

// add your Verilog code here to implement the parity generator/checker
  wire [n-1:0] count;
  wire [n-1:0] ones;
  wire [n-1:0] zeros;
  wire parity_bit;
  
  assign ones = in & {n{1'b1}};
  
  genvar i;
  generate
    for (i = 0; i < n; i = i + 1) begin : COUNT_ONES
      if (i == 0) 
        assign count[i] = ones[i];
      else 
        assign count[i] = ones[i] ^ count[i-1];
    end
  endgenerate
  
  assign parity_bit = (parity == 0) ? ~count[n-1] : count[n-1];
  
  assign out = (parity_bit == parity_mode) ? 1'b1 : 1'b0;
  assign err = (parity_bit == parity_mode) ? 1'b0 : 1'b1;

endmodule