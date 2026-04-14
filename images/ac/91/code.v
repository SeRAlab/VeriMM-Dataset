module top_module(
  output reg [2:0] cycle,
  input clk,
  input enn
);reg [2:0] register = 3'b000;

  always @(posedge clk) begin
    if(!enn)
      register <= (register == 3'b111) ? 3'b000 : register + 1;
    else
      register <= 3'b000;
  end
  
  assign cycle = register;
  
endmodule