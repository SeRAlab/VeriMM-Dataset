module top_module( IN0, IN1, CTRL, OUT1 );input [3:0] IN0;
  input [3:0] IN1;
  output reg [3:0] OUT1;  // Changed to reg type because we are using procedural assignments
  input CTRL;

  always @(*) begin
    case (CTRL)
      1'b0: OUT1 = IN0;  // If CTRL is 0, output IN0
      1'b1: OUT1 = IN1;  // If CTRL is 1, output IN1
      default: OUT1 = 4'b0000; // Default case (safeguard)
    endcase
  end

endmodule