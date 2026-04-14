module top_module(
  input   clock,
  input   reset
);wire  _T_1; 
  assign _T_1 = reset == 1'h0; 
  always @(posedge clock) begin
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_1) begin
          $fwrite(32'h80000002," !\"#$%%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"); 
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif 
    `ifndef SYNTHESIS
    `ifdef STOP_COND
      if (`STOP_COND) begin
    `endif
        if (_T_1) begin
          $finish; 
        end
    `ifdef STOP_COND
      end
    `endif
    `endif 
  end
endmodule