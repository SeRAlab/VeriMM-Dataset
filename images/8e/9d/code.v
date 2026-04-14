module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  input [1:0] sel,
  output reg [n-1:0] Y // Change output from wire to reg
);parameter n = 4; // number of bits in the binary numbers

// Define Boolean functions for the bitwise logical operations
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

// Connect the inputs to the corresponding logical gates
wire [n-1:0] and_out;
wire [n-1:0] or_out;
wire [n-1:0] xor_out;
wire [n-1:0] not_out;

assign and_out = and_func(A, B);
assign or_out = or_func(A, B);
assign xor_out = xor_func(A, B);
assign not_out = not_func(A);

// Compute the output signal Y based on the select signal
always @(*) begin
  case (sel)
    2'b00: Y = and_out;
    2'b01: Y = or_out;
    2'b10: Y = xor_out;
    2'b11: Y = not_out;
    default: Y = 0; // Adding default case for completeness
  endcase
end

endmodule