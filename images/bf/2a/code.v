module top_module(input clk, input reset,output io_in_ready,input io_in_valid,input [9:0] io_in_bits_addr,input io_in_bits_rw,input [191:0] io_in_bits_wData,input [9:0] io_in_tag,input io_out_ready,output io_out_valid,output[191:0] io_out_bits_rData,output[9:0] io_out_tag,input io_pcIn_valid,input io_pcIn_bits_request,input [15:0] io_pcIn_bits_moduleId,input [7:0] io_pcIn_bits_portId,input [19:0] io_pcIn_bits_pcValue,input [3:0] io_pcIn_bits_pcType,output io_pcOut_valid,output io_pcOut_bits_request,output[15:0] io_pcOut_bits_moduleId,output[7:0] io_pcOut_bits_portId,output[19:0] io_pcOut_bits_pcValue,output[3:0] io_pcOut_bits_pcType);reg[9:0] tagReg; 
  reg[0:0] hasReqReg; 
  assign io_out_tag = tagReg; 
  assign io_out_valid = hasReqReg; 
  assign io_in_ready = io_out_ready; 
  always @(posedge clk) begin 
  tagReg <= io_in_tag; 
  hasReqReg <= reset ? 1'h0 : io_in_valid; 
  end 
 endmodule