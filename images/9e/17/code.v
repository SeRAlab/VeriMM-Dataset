module top_module(
  input [n-1:0] in,
  input [clog2(n)-1:0] sel,
  output reg out
);parameter n = 4; // number of input signals

// Function to calculate the ceiling of log2
function integer clog2;
  input integer value;
  begin
    value = value - 1;
    for (clog2 = 0; value > 0; clog2 = clog2 + 1)
      value = value >> 1;
  end
endfunction

always @(*) begin
  case(sel)
    0: out = in[0];
    1: out = in[1];
    2: out = in[2];
    3: out = in[3];
    default: begin
      $display("Error: sel is out of range");
      out = 0;
    end
  endcase
end

endmodule