module top_module(
  input clk,
  input reset,
  input [15:0] in,
  output reg [15:0] out
);reg [7:0] in_low;
reg [7:0] in_high;
reg [7:0] mult1_out;
reg [7:0] mult2_out;
reg [15:0] pipeline_reg1;
reg [15:0] pipeline_reg2;

// Split input into two 8-bit parts
assign in_low = in[7:0];
assign in_high = in[15:8];

// First multiplier
always @(posedge clk) begin
  if (reset) begin
    mult1_out <= 0;
  end else begin
    mult1_out <= in_low * 3;
  end
end

// Second multiplier and pipeline register 1
always @(posedge clk) begin
  if (reset) begin
    mult2_out <= 0;
    pipeline_reg1 <= 0;
  end else begin
    mult2_out <= in_high * 3;
    pipeline_reg1 <= mult1_out;
  end
end

// Pipeline register 2 and output
always @(posedge clk) begin
  if (reset) begin
    pipeline_reg2 <= 0;
    out <= 0;
  end else begin
    pipeline_reg2 <= mult2_out;
    out <= pipeline_reg1 + pipeline_reg2;
  end
end

endmodule