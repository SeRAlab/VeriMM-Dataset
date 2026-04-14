module top_module(
  input [3:0] input1,
  input [3:0] input2,
  input [2:0] select,
  output reg [3:0] out  // Change 'output' to 'output reg'
);always @(*) begin
    case (select)
      3'b000: out = input1 & input2;
      3'b001: out = input1 | input2;
      3'b010: out = input1 ^ input2;
      default: out = 4'b0;
    endcase
  end

endmodule