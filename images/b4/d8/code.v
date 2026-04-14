module top_module(
  input signed [3:0] a,
  input signed [3:0] b,
  output signed [3:0] sum
);wire [3:0] carry;
  assign carry[0] = 1'b0;
  
  genvar i;
  generate
    for (i = 1; i < 4; i = i + 1) begin
      assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
    end
  endgenerate
  
  assign sum = a + b + {carry[3], carry[3:1]};

endmodule