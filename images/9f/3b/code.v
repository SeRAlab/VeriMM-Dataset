module top_module(
  input [DW-1:0] in,
  input clk,
  input reset,
  output reg [DW-1:0] out
);parameter DW = 32;
  
  // Internal state variables
  reg [DW-1:0] sync_reg0;
  reg [DW-1:0] sync_reg1;
  
  // Reset behavior
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      sync_reg0 <= {DW{1'b0}};
      sync_reg1 <= {DW{1'b0}};
      out <= {DW{1'b0}};
    end
    else begin
      sync_reg0 <= in;
      sync_reg1 <= sync_reg0;
      out <= sync_reg1;
    end
  end

endmodule