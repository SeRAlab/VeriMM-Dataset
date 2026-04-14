module top_module(
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] out // Change to reg type for output
);// initial block to set first bit of output vector
  initial begin
    // Use blocking assignments to set the output
    if (a + b >= 128) begin
      out[0] = 1;
    end else begin
      out[0] = 0;
    end
  end

  // bitwise AND operation
  always @(*) begin // Use an always block for combinational logic
    out[7:1] = a[7:1] & b[7:1]; // Corrected order of indices
  end

endmodule