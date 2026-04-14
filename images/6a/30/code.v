module top_module( IN0, IN1, CTRL, OUT1 );input [31:0] IN0;
  input [31:0] IN1;
  output [31:0] OUT1;
  input CTRL;

  wire [31:0] mux_outs;

  // Implement 32 individual 2:1 multiplexers
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : mux_loop
      assign mux_outs[i] = (CTRL) ? IN1[i] : IN0[i];
    end
  endgenerate

  // Assign the output directly to mux_outs
  assign OUT1 = mux_outs;

endmodule