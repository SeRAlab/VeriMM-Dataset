module top_module(sdma_req_i,sdma_sreq_i,sdma_done_o,sdma_active_o);input [3:0] sdma_req_i; 
  input [3:0] sdma_sreq_i; 
  output [3:0] sdma_done_o; 
  output [3:0] sdma_active_o; 
  reg [3:0] sdma_done_sig; 
  reg [3:0] sdma_active_sig; 
  assign sdma_done_o = sdma_done_sig; 
  assign sdma_active_o = sdma_active_sig; 
  initial begin 
  sdma_done_sig <= 4'h0; 
  sdma_active_sig <= 4'h0; 
  end 
 `ifndef YOSYS 
  task drive_dma_active; 
  input [3:0] dma_active_i; 
  begin 
  sdma_active_sig <= dma_active_i; 
  #100; 
  end 
  endtask 
 `endif 
 endmodule