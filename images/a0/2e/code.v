module top_module( ClrW, Wclk, Start, nRclk, RE, H_L, Depth, PerCnt, Delay,
                  Ready, Sampled, Full, Empty, Wptr, Rptr );input	  ClrW;         
  input	  Wclk;         
  input	  Start;        
  input   nRclk;        
  input   RE;           
  input   H_L;          
  input   [11:0]Depth;  
  input   [11:0]PerCnt; 
  input   [31:0]Delay;  
  
  output  Sampled;      
  output  Ready;        
  output  Full;         
  output  Empty;        
  output  [11:0]Wptr;   
  output  [11:0]Rptr;   

  reg     Full;
  reg     Ready; 
  reg     Loaded;       
  reg     [11:0]Wptr;
  reg     [11:0]Rptr;
  reg     [12:0]Pcnt;
  reg     [11:0]Bptr;
  reg     [31:0]DelayCnt;  

  reg     Sampled;

  always@ ( posedge Wclk or posedge ClrW ) begin
    if ( ClrW ) begin               
      Full <= 0;
      Pcnt <= 0;
      Sampled  <= 0;
      DelayCnt <= 0;  
      Ready    <= 0;              
    end else begin
      if ( Start )                      DelayCnt <= DelayCnt + 1;
      if ( Pcnt >= PerCnt )             Sampled  <= 1;
      if ( !Full )                      Wptr     <= Wptr + 1;
      if ( Pcnt >= Depth )              Full     <= Ready; 
      else                              Pcnt     <= Pcnt +1; 
      if(( !Start )&&( Pcnt >= PerCnt)) Pcnt     <= PerCnt;
      if ( DelayCnt == Delay ) begin  
        Ready <= 1;              
        Bptr  <= Wptr;                                       
        Pcnt  <= PerCnt;
      end  
    end 
  end

  assign Empty = ( Rptr == Wptr ) ? 1'b1 : 1'b0 ;
  
  always @( posedge nRclk or posedge ClrW ) begin
    if ( ClrW ) begin
      Loaded <= 0; 
      Rptr   <= 0;   
    end else begin 
      if ( H_L && RE )  Rptr <= Rptr + 1;
      if (( H_L )&& RE &&( ~Loaded )&& Start ) begin 
        Loaded <= 1;
        Rptr   <= Bptr - 151; 
      end  
    end   
  end

endmodule