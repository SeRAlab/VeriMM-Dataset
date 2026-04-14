module top_module(clock, reset, signal, irq, ack);input signal, ack, clock, reset; 
  output irq; 
  wire clock, reset, signal, ack; 
  reg irq, prevsignal; 
  always @(posedge clock or negedge reset) 
  if (~reset) 
  begin 
  prevsignal <= 0; 
  irq <= 0; 
  end 
  else 
  begin 
  if (signal && ~prevsignal) irq <= 1; 
  prevsignal <= signal; 
  if (ack) irq <= 0; 
  end 
 endmodule