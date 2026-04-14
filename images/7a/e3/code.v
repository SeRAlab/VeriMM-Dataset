module top_module(
  input RST,
  input CLK,
  input PRESET,
  input EN,
  input [31:0] PRESET_VAL,
  output ZERO
);reg [31:0] value;

  always @(posedge CLK, negedge RST)
  begin
    if (!RST)
    begin
      value <= 32'b0;
    end
    else
    begin
      if (PRESET) begin
        value <= PRESET_VAL;
      end else if (EN)
      begin
        value <= value - 1'b1;
      end
    end
  end

  assign ZERO = (value == 0 ? 1'b1 : 1'b0);

endmodule