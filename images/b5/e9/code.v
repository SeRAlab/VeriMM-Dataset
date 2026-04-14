module top_module(
  input signed [7:0] inp,
  output reg signed [7:0] out_srl,
  output reg signed [7:0] out_sll,
  output reg signed [7:0] out_sra,
  output reg signed [7:0] out_sla,
  output reg signed [7:0] out_shl_u,
  output reg signed [7:0] out_shr_u,
  output reg signed [7:0] out_shl_s,
  output reg signed [7:0] out_shr_s
);always @(inp) begin
    out_srl = inp >>> 1;
    out_sll = inp << 1;
    out_sra = inp >> 1;
    out_sla = inp << 1;
    out_shl_u = inp << 1;
    out_shr_u = inp >>> 1;
    out_shl_s = inp << 1;
    out_shr_s = inp >> 1;
  end

endmodule