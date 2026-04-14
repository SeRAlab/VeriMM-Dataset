module top_module(input [ 5 : 0 ] irqVector,input [ 17 : 1 ] irqOffset,output [ 7 : 0 ] irqNumber);`ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET 
  parameter HANDLER_BASE = 17'h100; 
  parameter HANDLER_SHIFT = 4; 
  assign irqNumber = ((irqOffset - HANDLER_BASE) >> HANDLER_SHIFT); 
  `else 
  assign irqNumber = {2'b0, irqVector }; 
  `endif 
 endmodule