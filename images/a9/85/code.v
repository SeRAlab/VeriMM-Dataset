module top_module(
  input CLK, // clock input
  input EN, // enable input
  input TE, // test enable input
  output reg ENCLK // clock gated output
);always @ (posedge CLK) begin
    if (EN && TE) begin
      ENCLK <= 1'b1;
    end
    else begin
      ENCLK <= 1'b0;
    end
  end

endmodule