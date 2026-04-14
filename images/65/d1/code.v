module top_module(
  input [7:0] in,
  input rst,
  output reg out
);integer i;
  reg parity;

  always @(*) begin
    parity = 1'b0;
    for(i=0; i<8; i=i+1) begin
      parity = parity ^ in[i];
    end
    out = parity;
  end

  always @(posedge rst) begin
    if(rst) begin
      out <= 1'b0;
    end
  end

endmodule