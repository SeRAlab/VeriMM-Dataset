module top_module(
  input clk,
  input [63:0]probe0,
  input [63:0]probe1,
  output reg [15:0]device_out,
  output reg [47:0]action_out
);always @(posedge clk) begin
    case (probe0[15:0])
      16'h0001: device_out <= 16'h0001;
      16'h0002: device_out <= 16'h0002;
      16'h0003: device_out <= 16'h0003;
      16'h0004: device_out <= 16'h0004;
      default: device_out <= 16'hFFFF;
    endcase

    case (probe1[47:0])
      48'h000000000001: action_out <= 48'h000000000001;
      48'h000000000002: action_out <= 48'h000000000002;
      48'h000000000003: action_out <= 48'h000000000003;
      48'h000000000004: action_out <= 48'h000000000004;
      48'h000000000005: action_out <= 48'h000000000005;
      48'h000000000006: action_out <= 48'h000000000006;
      default: action_out <= 48'hFFFFFFFFFFFF;
    endcase
  end

endmodule