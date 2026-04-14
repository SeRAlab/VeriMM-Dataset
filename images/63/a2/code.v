module top_module(
  input [3:0] spiclkcounter,
  input spien,
  input mode,
  output addrt,
  output spioe,
  output rdt,
  output rdld,
  output wrt,
  output modet);reg modetreg;
  reg addrtreg;
  reg rdtreg;
  reg wrtreg;
  reg rdldreg;
  reg spioereg;
  
  assign modet = modetreg;
  assign addrt = addrtreg;
  assign rdt = rdtreg;
  assign wrt = wrtreg;
  assign rdld = rdldreg;
  assign spioe = spioereg;
  
  always @(*) begin
    modetreg = 0;
    rdtreg = 0;
    addrtreg = 0;
    wrtreg = 0;
    rdldreg = 0;
    spioereg = spien & mode;
    
    case(spiclkcounter)
      4'h0:
        modetreg <= 1; 

      4'h1, 4'h2, 4'h3, 4'h4:
      	addrtreg <= spien; 
      
      
      4'h5, 4'h6, 4'h7:
        rdtreg <= (mode & spien); 
      
      4'h8:
        begin
          rdtreg <= (mode & spien); 
          rdldreg <= (mode & spien); 
          wrtreg <= (~mode & spien); 
        end
        
      4'h9, 4'ha, 4'hb, 
      4'hc, 4'hd, 4'he, 4'hf:
        wrtreg <= (~mode & spien); 
     
      default:
        begin
          rdtreg <= 1'bx;
          wrtreg <= 1'bx;
          addrtreg <= 1'bx;
          modetreg <= 1'bx;
          rdldreg <= 1'bx;
        end   
    endcase
  end
endmodule