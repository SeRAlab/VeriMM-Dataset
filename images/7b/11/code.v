module top_module(input clock,input reset,input [31:0] io_input_data,input [31:0] io_input_init,input io_input_enable,input io_input_reset,output [31:0] io_output_data);reg [31:0] ff; 
  reg [31:0] _GEN_0; 
  wire [31:0] _T_17; 
  wire [31:0] _T_18; 
  wire [31:0] _T_19; 
  assign io_output_data = _T_19; 
  assign _T_17 = io_input_enable ? io_input_data : ff; 
  assign _T_18 = io_input_reset ? io_input_init : _T_17; 
  assign _T_19 = io_input_reset ? io_input_init : ff; 
 `ifdef RANDOMIZE 
  integer initvar; 
  initial begin 
  `ifndef verilator 
  #0.002 begin end 
  `endif 
  `ifdef RANDOMIZE_REG_INIT 
  _GEN_0 = {1{$random}}; 
  ff = _GEN_0[31:0]; 
  `endif 
  end 
 `endif 
  always @(posedge clock) begin 
  if (reset) begin 
  ff <= io_input_init; 
  end else begin 
  if (io_input_reset) begin 
  ff <= io_input_init; 
  end else begin 
  if (io_input_enable) begin 
  ff <= io_input_data; 
  end 
  end 
  end 
  end 
 endmodule