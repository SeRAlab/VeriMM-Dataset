module top_module(input [1:0] A, B, input [1:0] S, output reg [1:0] O);wire [1:0] sum;
  wire [1:0] diff;

  // Calculate sum and difference
  assign sum = A + B;
  assign diff = {A[1] ^ B[1], A[0] ^ B[0]} + {~B[1], ~B[0], 1'b0};

  // Use a 2-to-1 multiplexer to select output based on S
  always @(*) begin
    case (S)
      2'b00: O = sum;  // When S is 00, output the sum
      2'b01: O = diff; // When S is 01, output the difference
      default: O = 2'b00; // Default case
    endcase
  end

endmodule