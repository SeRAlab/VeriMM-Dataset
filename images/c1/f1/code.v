module sysgen_logical_2d2e86ecb2 (
  input [(1 - 1):0] d0,
  input [(1 - 1):0] d1,
  output [(1 - 1):0] y,
  input clk,
  input ce,
  input clr);
  reg [(1 - 1):0] d0_1_24;
  reg [(1 - 1):0] d1_1_27;
  wire fully_2_1_bit;
  
  always @(posedge clk) begin
    if (ce) begin
      d0_1_24 <= d0;
      d1_1_27 <= d1;
    end
  end
  
  assign fully_2_1_bit = d0_1_24 & d1_1_27;
  assign y = fully_2_1_bit;
  
  initial begin
    d0_1_24 = 1'b0;
    d1_1_27 = 1'b0;
  end
  
  always @(posedge clk) begin
    if (clr) begin
      d0_1_24 <= 1'b0;
      d1_1_27 <= 1'b0;
    end
  end
  
endmodule