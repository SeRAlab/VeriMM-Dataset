module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input [1:0] ctrl,
  output reg [n-1:0] res  // Change to output reg to allow assignment in always block
);parameter n = 8; // number of bits in binary numbers

// Define logical functions as Boolean functions of input binary numbers
function [n-1:0] and_func;
  input [n-1:0] a, b;
  begin
    and_func = a & b;
  end
endfunction

function [n-1:0] or_func;
  input [n-1:0] a, b;
  begin
    or_func = a | b;
  end
endfunction

function [n-1:0] xor_func;
  input [n-1:0] a, b;
  begin
    xor_func = a ^ b;
  end
endfunction

function [n-1:0] not_func;
  input [n-1:0] a;
  begin
    not_func = ~a;
  end
endfunction

// Connect inputs to control signal and control signal to appropriate logical function
always @(*) begin
  case(ctrl)
    2'b00: res = and_func(a, b);
    2'b01: res = or_func(a, b);
    2'b10: res = xor_func(a, b);
    2'b11: res = not_func(a);
    default: res = 0; // Default case to avoid latches
  endcase
end

endmodule