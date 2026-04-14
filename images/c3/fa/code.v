module clock_and_case (
  input clk,
  input [3:0] sig,
  output reg [7:0] thing
);

  // generate a clock
  always #10 clk = ~clk;

  // set specific bits in thing based on sig
  always @ (sig)
    case (sig)
      4'b0000: thing[0] = 1'b1;
      4'b0010: thing[2] = 1'b1;
      4'b0011: thing[9] = 1'b1;
      default:  thing = thing; // do nothing
    endcase

endmodule