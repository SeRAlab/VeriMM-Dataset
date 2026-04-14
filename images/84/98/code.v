module top_module(din, clk, rst_l, load, q);parameter SIZE = 1;

  input   [SIZE-1:0]      din ;   // data in
  input                   clk ;   // clk or scan clk
  input                   rst_l ;   // reset
  input                   load ;   // load

  output  [SIZE-1:0]      q ;     // output

  reg [SIZE-1:0] q;
  always @ (posedge clk or negedge rst_l)
    if (~rst_l) begin
      q <= {SIZE{1'b0}};
    end else if (load) begin
      q <= din;
    end else begin
      q <= q;
    end

endmodule