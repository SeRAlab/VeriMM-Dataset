module top_module(
  input CLOCKENABLE,
  input DOUT0,
  input DOUT1,
  input INPUTCLK,
  input LATCHINPUTVALUE,
  input OUTPUTCLK,
  input OUTPUTENABLE,
  output reg DIN0,
  output reg DIN1
);reg [1:0] data;

  always @(posedge CLOCKENABLE) begin
    if (DOUT0 && DOUT1) begin
      data <= {DOUT1, DOUT0};
    end
  end

  always @(posedge INPUTCLK) begin
    if (LATCHINPUTVALUE) begin
      DIN0 <= data[0];
      DIN1 <= data[1];
    end
  end

  always @(posedge OUTPUTCLK) begin
    if (OUTPUTENABLE) begin
      DIN0 <= data[0];
      DIN1 <= data[1];
    end
  end

endmodule