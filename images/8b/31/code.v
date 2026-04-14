module top_module(tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user);input tms, tck, tdi, ntrst, tdoutap, tdouser; 
  output tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser; 
  output updateuser, runidleuser, usr1user; 
  parameter lpm_type = "cycloneii_jtag"; 
  initial 
  begin 
  end 
  always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
  begin 
  end 
 endmodule