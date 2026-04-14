module top_module(CLK,RST,IN, OUT);input CLK, RST, IN;
  output OUT;
  reg reg1;
  wire IN;
  wire OUT = reg1;

  always @(posedge CLK or negedge RST) begin
    if(RST) begin
      reg1 <= 1'b0;
    end else begin
      reg1 <= 1'b1;
    end
  end

endmodule