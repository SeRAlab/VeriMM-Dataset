module top_module(
           input CLK_IN,
           input reset,
           input enb_1_2000_0,
           input Reset_1,
           input signed [31:0] In,
           output signed [31:0] Out
          );wire signed [31:0] Constant1_out1;
  wire signed [31:0] Reset_Switch1_out1;
  reg signed [31:0] In_Delay_out1;
  wire signed [31:0] Constant_out1;
  wire signed [31:0] Reset_Switch_out1;

  assign Constant1_out1 = 32'sb00000000000000000000000000000000;
  assign Reset_Switch1_out1 = (Reset_1 == 1'b0 ? In : Constant1_out1);

  always @(posedge CLK_IN) begin
    if (reset == 1'b1) begin
      In_Delay_out1 <= 32'sb00000000000000000000000000000000;
    end
    else if (enb_1_2000_0) begin
      In_Delay_out1 <= Reset_Switch1_out1;
    end
  end

  assign Constant_out1 = 32'sb00000000000000000000000000000000;
  assign Reset_Switch_out1 = (Reset_1 == 1'b0 ? In_Delay_out1 : Constant_out1);

  assign Out = Reset_Switch_out1;

endmodule