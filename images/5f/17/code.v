module top_module(
      input   io_clear,
      input  [15:0] io_limit,
      output  io_overflow,
      input   io_mainClk,
      input   resetCtrl_systemReset);reg [15:0] counter;
  assign io_overflow = (counter == io_limit);
  always @ (posedge io_mainClk) begin
    if (resetCtrl_systemReset) begin
      counter <= 16'b0;
    end else if (io_clear) begin
      counter <= 16'b0;
    end else if (io_overflow) begin
      counter <= 16'b0;
    end else begin
      counter <= counter + 16'b1;
    end
  end
endmodule