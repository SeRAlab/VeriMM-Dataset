module top_module(
  input [n-1:0] ctrl,
  output out
);parameter n = 5; // number of control signals
parameter m = 256; // number of steps in the resistor ladder

reg [m-1:0] ladder; // resistor ladder
wire [m-1:0] selected; // selected resistors
wire [m-1:0] resistance; // resistance of selected resistors

// create resistor ladder
generate
  genvar i;
  for (i = 0; i < m; i = i + 1) begin
    assign ladder[i] = (i < m/2) ? 1'b1 : 1'b0;
  end
endgenerate

// select resistors based on control signals
assign selected = {ctrl, {n{1'b0}}};

// calculate resistance of selected resistors
assign resistance = ladder & selected;
assign out = $countones(resistance);

endmodule