module top_module(input [1:0] data, input ctrl, output reg out);always @(*) begin
    case(ctrl)
      1'b0: out = data[0];
      1'b1: out = data[1];
      default: out = 1'b0; // Adding default case for safety
    endcase
  end

endmodule