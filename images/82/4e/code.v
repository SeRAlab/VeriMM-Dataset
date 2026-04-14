module top_module(
  input signed [n-1:0] div,
  input signed [n-1:0] dvsr,
  output reg signed [n-1:0] quot,
  output reg signed [n-1:0] rem
);parameter n = 8; // number of bits

always @(*) begin
  if (dvsr == 0) begin
    quot = 'bx;
    rem = 'bx;
  end
  else if (div >= 0 && dvsr >= 0) begin // unsigned division
    quot = div / dvsr;
    rem = div % dvsr;
  end
  else if (div < 0 && dvsr < 0) begin // signed division
    quot = $signed($unsigned(div) / $unsigned(dvsr));
    rem = $signed($unsigned(div) % $unsigned(dvsr));
  end
  else if (div < 0 && dvsr >= 0) begin // signed dividend, unsigned divisor
    quot = -(-div / dvsr);
    rem = -(-div % dvsr);
  end
  else begin // unsigned dividend, signed divisor
    quot = div / $signed(dvsr);
    rem = div % $signed(dvsr);
  end
end

endmodule