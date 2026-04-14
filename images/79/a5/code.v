module mux_2to1 
(
  input sel,
  input [7:0] in0,
  input [7:0] in1,

  output reg [7:0] out
);

  always @(*) begin
    case (sel)
      1'b0: out = in0;
      1'b1: out = in1;
      default: out = 8'b00000000; // Default to 0 if the select signal is invalid
    endcase
  end

endmodule