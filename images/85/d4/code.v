module top_module(
  input in,
  input [select_lines-1:0] sel,
  output reg [2**select_lines-1:0] out // Changed to reg type
);parameter select_lines = 3; // number of select lines (log2 of number of output signals)

always @(*) begin
  case(sel)
    0: out = {in, {2**select_lines-2{1'b0}}}; // distribute input signal to out0
    1: out = {{2**select_lines-1{1'b0}}, in, {2**select_lines-2{1'b0}}}; // distribute input signal to out1
    2: out = {{2**select_lines-2{1'b0}}, in, {2**select_lines-2{1'b0}}}; // distribute input signal to out2
    // and so on, until sel = n-1
    default: out = {2**select_lines{1'b0}}; // all other output signals should be 0
  endcase
end

endmodule