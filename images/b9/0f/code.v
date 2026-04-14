module top_module(
  input [n-1:0] in,
  output reg [log2(n)-1:0] out
);parameter n = 8; // number of input signals

// Function to calculate the log base 2
function integer log2;
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

always @* begin
  if (in != 0) begin
    out = log2(n); // Assign the highest active bit's index
  end else begin
    out = 0; // Default case if no inputs are active
  end
end

endmodule