module top_module(
  input [n-1:0] in,
  output reg [log2(n)-1:0] out
);parameter n = 4; // number of input signals

// Function to calculate log2
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
  if (in == 0) begin
    out = 0;
  end else begin
    casez (in)
      4'b???1: out = 2'd0; // Corresponding to input 1
      4'b??10: out = 2'd1; // Corresponding to input 2
      4'b?100: out = 2'd2; // Corresponding to input 3
      4'b1000: out = 2'd3; // Corresponding to input 4
      default: out = 0;    // Safety default
    endcase
  end
end

endmodule