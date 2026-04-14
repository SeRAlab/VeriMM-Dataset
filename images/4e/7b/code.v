module top_module(I, S, clk, O0, O1);input [11:0] I;
  input S, clk;
  output reg [11:0] O0, O1;

  wire [11:0] notI, and0, and1, or0, or1, xor0, xor1, nand0, nand1, nor0, nor1;

  assign notI = ~I;
  assign and0 = notI & S;
  assign and1 = I & S;
  assign or0 = notI | and0;
  assign or1 = I | and1;
  assign xor0 = notI ^ and0;
  assign xor1 = I ^ and1;
  assign nand0 = ~(notI & S);
  assign nand1 = ~(I & S);
  assign nor0 = ~(notI | and0);
  assign nor1 = ~(I | and1);

  always @(posedge clk) begin
    O0 <= or0;      // Edge triggered on clk
    O1 <= or1;      
  end

  always @(posedge clk) begin
    O0 <= xor0;     // Update O0 with the result of xor0
    O1 <= xor1;     
  end

  always @(posedge clk) begin
    O0 <= nand0;    // Update O0 with the result of nand0
    O1 <= nand1;    
  end

  always @(posedge clk) begin
    O0 <= nor0;     // Update O0 with the result of nor0
    O1 <= nor1;     
  end
endmodule