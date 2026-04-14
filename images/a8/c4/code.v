module top_module(
  input signed [n+m-1:0] x,
  input signed [n+m-1:0] y,
  input [1:0] ctrl,
  output reg signed [n+m-1:0] z // Changed to 'reg' type
);parameter n = 4; // number of bits used to represent the integer part of the fixed-point numbers
parameter m = 8; // number of bits used to represent the fractional part of the fixed-point numbers

// Addition
function signed [n+m-1:0] add;
  input signed [n+m-1:0] a;
  input signed [n+m-1:0] b;
  begin
    add = a + b;
  end
endfunction

// Subtraction
function signed [n+m-1:0] sub;
  input signed [n+m-1:0] a;
  input signed [n+m-1:0] b;
  begin
    sub = a - b;
  end
endfunction

// Multiplication
function signed [n+m-1:0] mul;
  input signed [n+m-1:0] a;
  input signed [n+m-1:0] b;
  begin
    mul = $signed(a * b) >> m;
  end
endfunction

// Division
function signed [n+m-1:0] div;
  input signed [n+m-1:0] a;
  input signed [n+m-1:0] b;
  begin
    div = $signed(a << m) / b;
  end
endfunction

// Connect inputs to appropriate arithmetic blocks
always @(*) begin
  case(ctrl)
    2'b00: z = add(x, y);
    2'b01: z = sub(x, y);
    2'b10: z = mul(x, y);
    2'b11: z = div(x, y);
    default: z = 0; // Added default case for safety
  endcase
end

endmodule