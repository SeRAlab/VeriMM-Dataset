module top_module(
      input   io_tick,
      input   io_clear,
      input  [15:0] io_limit,
      output  io_full,
      output [15:0] io_value,
      input   io_mainClk,
      input   resetCtrl_systemReset);reg [15:0] counter;
  wire limitHit;
  reg inhibitFull;
  
  assign limitHit = (counter == io_limit);
  assign io_full = ((limitHit && io_tick) && (! inhibitFull));
  assign io_value = counter;
  
  always @ (posedge io_mainClk or posedge resetCtrl_systemReset) begin
    if (resetCtrl_systemReset) begin
      counter <= 16'b0;
      inhibitFull <= 1'b0;
    end else begin
      if (io_clear) begin
        counter <= 16'b0;
        inhibitFull <= 1'b0;
      end else begin
        if (io_tick) begin
          counter <= counter + 1;
          inhibitFull <= limitHit;
        end
      end
    end
  end

endmodule