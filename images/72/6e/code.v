module top_module(
  input [n-1:0] data,
  input [m-1:0] match,
  output [n-1:0] data_out,
  output match_out
);parameter n = 8; // number of data lines and match lines
parameter m = 4; // number of match lines

reg [n-1:0] data_reg;
assign data_out = data_reg;

wire [m-1:0] match_wire;
assign match_wire = match;

wire match_found;
assign match_out = match_found;

// Implement CAM functionality using AND gates
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : and_gate_loop
    wire [m-1:0] and_out;
    assign and_out = data[i] & match_wire;
    assign match_found = |and_out;
    always @ (and_out) begin
      if (and_out == {m{1'b1}}) begin
        data_reg <= data[i];
      end
    end
  end
endgenerate

endmodule