module top_module(DOUT, RA, rd_in, DIN, WA, wr_in, memclk, rst);parameter Z=511;
parameter W=6;
parameter COLADDR_BITS=9;
parameter COLDEPTH = Z;
output reg[(W)-1:0] DOUT;
input[(COLADDR_BITS)-1:0] RA;
input rd_in;
input[(W)-1:0] DIN;
input[(COLADDR_BITS)-1:0] WA;
input wr_in;
input memclk, rst;

reg[W-1:0] Lmemreg[COLDEPTH-1:0];













    
    always@(negedge memclk)
    begin
        if(!rst)
        begin
          DOUT<=0;
          
          
          
        end
        else
        begin
          DOUT<= rd_in ? Lmemreg[RA] : 0;
          
          
          
        end
    end 
    
    always@(posedge memclk)
    begin
      if(!rst)
      begin
        Lmemreg[WA]<=Lmemreg[WA];
        
        
        
      end
      else
      begin
        Lmemreg[WA]<=(wr_in ? (DIN) : Lmemreg[WA] );
        
        
        
      end
    end  
    



endmodule