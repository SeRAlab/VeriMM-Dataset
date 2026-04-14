module top_module( clock, reset, outClk );input            clock;
  input            reset;

  wire             clockMod4;
  reg     [1:0]    cnt; 

  output  reg      outClk;

  assign clockMod4 = ( cnt == 2'd3 ); 

  always @ ( posedge clock or posedge reset )
    if ( reset ) 
      cnt <= 0; 
    else 
      cnt <= cnt + 1;

  always @ ( posedge clockMod4 or posedge reset )
    if ( reset ) 
      outClk <= 0; 
    else 
      outClk <= ~outClk;

endmodule