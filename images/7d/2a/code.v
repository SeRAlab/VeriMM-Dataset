module top_module(
  input clk,
  input [3:0] sig,
  output reg [7:0] thing
);// Initial block to set initial state
  initial begin
    thing = 8'b00000000; // Initialize thing
  end

  // always block to react to the clock edge
  always @(posedge clk) begin
    case (sig)
      4'b0000: thing[0] = 1'b1;
      4'b0010: thing[2] = 1'b1;
      4'b0011: thing[1] = 1'b1; // corrected index, since `thing` only has 8 bits
      default: thing = thing; // do nothing
    endcase
  end

endmodule