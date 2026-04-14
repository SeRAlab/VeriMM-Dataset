module top_module(
				   iClk, 
					iSignal, 
					oSignal
					);input iClk;
  input iSignal;
  output oSignal;
  
  
  
  
  
  reg buffer_before;
  reg buffer_after;
   
  always @(posedge iClk)
  begin
    buffer_before <= iSignal;
  end
  
  always @(posedge iClk)
  begin
    buffer_after <= buffer_before;
  end
	
  assign oSignal = (buffer_before && !buffer_after);

endmodule