module top_module(CLK,       
             DIN,       
             RST,       
             IN_EN,     
             OUT_EN,     
             DOUT,      
             FULL,      
             EMPTY      
            );input                    CLK;
    input [18:0]   DIN;
    input                    RST;
    input                    IN_EN;
    input                    OUT_EN;
    output[18:0]   DOUT;
    output                   FULL;
    output                   EMPTY; 
    
    wire                 empty_en;
    wire                 full_en;
    
    reg [3:0]            cnthead;
    reg [3:0]            cnttail;
    reg                  full;
    reg                  empty;
    reg [18:0] fifo [0:15] ;
    reg [18:0] DOUT_temp;
    reg  [4:0] fcnt;
    
                
   
    
    
     always @(posedge CLK or posedge RST)
  begin
   if(RST)
          fcnt<=5'b0;
   else if((!OUT_EN&&IN_EN)||(OUT_EN&&!IN_EN))
      begin
       if(IN_EN)
          fcnt<=fcnt+1'b1;
       else           
          fcnt<=fcnt-1'b1;
      end
   else   fcnt<=fcnt;
  end
  
    
    always@(posedge CLK or posedge RST )
    if(RST)
      cnthead=4'b0000;
    else if(OUT_EN)
      cnthead=cnthead+1;
      
    
    always@(posedge CLK or posedge RST )
    if(RST)
      cnttail=4'b0000;
    else if(IN_EN)
      cnttail=cnttail+1;
      
      
    always@(posedge CLK or posedge RST )
    if(RST)
      full=0;
    else if(full_en)
      full=1;
      
      
    always@(posedge CLK or posedge RST )
      if(RST)
        empty=0;
      else if(empty_en)
        empty=1;
        
    
    always@(IN_EN )
    begin
       if(IN_EN)
         fifo[cnttail]=DIN;
    end
    
    
   always@( OUT_EN)
   begin
       if(OUT_EN)
         DOUT_temp=fifo[cnthead];
       else
         DOUT_temp=19'h00000;
   end
   
   
   assign  full_en=((fcnt==5'b01111&&IN_EN))? 1:0;
   assign  empty_en=((fcnt==5'b00001&&OUT_EN))? 1:0;
   assign  DOUT=DOUT_temp;
   assign  FULL=full;
   assign  EMPTY=empty;
   
 endmodule