module top_module(



  input  wire        PCLK,     
  input  wire        PCLKG,    
  input  wire        PRESETn,  

  input  wire        PSEL,     
  input  wire [11:2] PADDR,    
  input  wire        PENABLE,  
  input  wire        PWRITE,   
  input  wire [31:0] PWDATA,   

  input  wire [3:0]  ECOREVNUM,

  output wire [31:0] PRDATA,   
  output wire        PREADY,   
  output wire        PSLVERR,  

  input  wire        RXD,      
  output wire        TXD,      
  output wire        TXEN,     
  output wire        BAUDTICK, 

  output wire        TXINT,    
  output wire        RXINT,    
  output wire        TXOVRINT, 
  output wire        RXOVRINT, 
  output wire        UARTINT);assign PREADY = 1'b1;
  assign PSLVERR = 1'b0;
  assign TXEN = 1'b0;
  assign BAUDTICK = 1'b0;
  assign TXINT = 1'b0;
  assign RXINT = 1'b0;
  assign TXOVRINT = 1'b0;
  assign RXOVRINT = 1'b0;
  assign UARTINT = 1'b0;
  
endmodule