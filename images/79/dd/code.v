module top_module(
  input Up_Down,
  input CLK,
  input [7:0] Data,
  output reg [6:0] Resistance
);reg [6:0] resistance_value;

  always @(posedge CLK) begin
    if (Up_Down) begin
      resistance_value <= resistance_value + 1;
    end else begin
      resistance_value <= resistance_value - 1;
    end
  end

  always @(posedge CLK) begin
    if (Data > 0) begin
      if (Up_Down) begin
        resistance_value <= resistance_value + 1;
      end else begin
        resistance_value <= resistance_value - 1;
      end
    end
  end

  always @(posedge CLK) begin
    if (resistance_value > 100) begin
      resistance_value <= 100;
    end else if (resistance_value < 0) begin
      resistance_value <= 0;
    end
  end

  assign Resistance = resistance_value;

endmodule