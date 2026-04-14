module top_module(
  input [31:0] in,
  input [3:0] control,
  output reg [15:0] out
);always @(*) begin
    case (control)
      0: out = 16'b0;
      1: out = in[31:16];
      2: out = in[15:0];
      3: out = in[31:16] >> 16;
      4: out = in[15:0] >> 16;
      5: out = in[31:16] >> 16;
      6: out = in[15:0] >> 16;
      default: out = 16'b0;
    endcase
  end

endmodule