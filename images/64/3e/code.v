module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input and_en,
  input or_en,
  input xor_en,
  input not_en,
  input inv_en,
  output reg [n-1:0] and_out,
  output reg [n-1:0] or_out,
  output reg [n-1:0] xor_out,
  output reg [n-1:0] not_out
);parameter n = 4; // number of bits in the input and output signals

// AND operation
always @ (a, b, and_en)
begin
  if (and_en)
    and_out = a & b;
  else
    and_out = 0;
end

// OR operation
always @ (a, b, or_en)
begin
  if (or_en)
    or_out = a | b;
  else
    or_out = 0;
end

// XOR operation
always @ (a, b, xor_en)
begin
  if (xor_en)
    xor_out = a ^ b;
  else
    xor_out = 0;
end

// NOT operation
always @ (a, not_en)
begin
  if (not_en)
  begin
    if (inv_en)
      not_out = ~a;
    else
      not_out = !a;
  end
  else
    not_out = 0;
end

endmodule