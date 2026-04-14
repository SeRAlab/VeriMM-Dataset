module top_module(
  input in,
  input [log2(m)-1:0] sel,
  output [m-1:0] out
);parameter m = 4; // number of output signals

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

reg [m-1:0] one_hot;

always @* begin
  one_hot = 0; // Initialize one_hot to zero
  case (sel)
    0: one_hot[0] = 1'b1;
    1: one_hot[1] = 1'b1;
    2: one_hot[2] = 1'b1;
    3: one_hot[3] = 1'b1;
    // add more cases for larger m if required
    default: one_hot = 0; // Ensure one_hot is 0 for invalid selection
  endcase
end

assign out = one_hot & {m{in}}; // Use 'm' replication to drive the output

endmodule