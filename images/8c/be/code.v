module top_module(inD, inE, outQ);input inD, inE;
  output outQ;
  reg Q;
  always @ (inD or inE)
  if(inE)
  begin
    Q <= inD;
  end
 assign outQ = Q;
endmodule