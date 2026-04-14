module top_module(
  input in,
  input [log2(n)-1:0] sel,
  output reg [n-1:0] out
);parameter n = 8; // number of output signals

// Function to compute log2 of a number
function integer log2;
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

always @(*) begin
  out = {n{1'b0}}; // initialize all output signals to 0
  case(sel)
    0: out[0] = in;
    1: out[1] = in;
    2: out[2] = in;
    3: out[3] = in;
    4: out[4] = in;
    5: out[5] = in;
    6: out[6] = in;
    7: out[7] = in;
    default: out = {n{1'b0}}; // if sel is out of range, set all outputs to 0
  endcase
end

endmodule