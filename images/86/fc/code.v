module top_module(
  input clock,
  input [3:0] id_control_signals,
  input reset,
  output reg [3:0] ex_control_signals,
  output reg [3:0] mem_control_signals,
  output reg [3:0] wb_control_signals
);always @(posedge clock) begin
    if (reset) begin
      ex_control_signals <= 4'b0;
      mem_control_signals <= 4'b0;
      wb_control_signals <= 4'b0;
    end else begin
      ex_control_signals <= id_control_signals;
      mem_control_signals <= ex_control_signals;
      wb_control_signals <= mem_control_signals;
    end
  end

endmodule