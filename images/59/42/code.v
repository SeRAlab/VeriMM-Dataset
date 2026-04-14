module top_module(input [63:0] io_ins_0_0_addr,input io_ins_0_0_isWr,input [15:0] io_ins_0_0_size,input [63:0] io_ins_1_0_addr,input io_ins_1_0_isWr,input [15:0] io_ins_1_0_size,input io_sel,output [63:0] io_out_0_addr,output io_out_0_isWr,output [15:0] io_out_0_size);wire [15:0] _GEN_0_0_size; 
  wire [63:0] _GEN_4; 
  wire _GEN_5; 
  wire [15:0] _GEN_7; 
  wire _GEN_2_0_isWr; 
  wire [63:0] _GEN_3_0_addr; 
  assign _GEN_4 = io_sel ? io_ins_1_0_addr : io_ins_0_0_addr; 
  assign _GEN_5 = io_sel ? io_ins_1_0_isWr : io_ins_0_0_isWr; 
  assign _GEN_7 = io_sel ? io_ins_1_0_size : io_ins_0_0_size; 
  assign io_out_0_addr = _GEN_3_0_addr; 
  assign io_out_0_isWr = _GEN_2_0_isWr; 
  assign io_out_0_size = _GEN_0_0_size; 
  assign _GEN_0_0_size = _GEN_7; 
  assign _GEN_2_0_isWr = _GEN_5; 
  assign _GEN_3_0_addr = _GEN_4; 
 endmodule