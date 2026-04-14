module top_module(
     
     ENABLE_ERR_DETECT,
     HARD_ERR_RESET,
 
     
     HARD_ERR,
     SOFT_ERR,
 
     
     ILLEGAL_BTF,
 
     
     RX_BUF_ERR,
     TX_BUF_ERR,
     RX_HEADER_0,
     RX_HEADER_1,
     RX_HEADER_ERR,
     RXDATAVALID_IN,
 
     
     USER_CLK
 );`define DLY #1
 
 
 
     
       input                ENABLE_ERR_DETECT; 
       output               HARD_ERR_RESET; 
 
     
       input                ILLEGAL_BTF; 
 
     
       input                RX_BUF_ERR; 
       input                TX_BUF_ERR; 
       input                RX_HEADER_0; 
       input                RX_HEADER_1; 
       input                RX_HEADER_ERR; 
       input                RXDATAVALID_IN; 
 
     
       input                USER_CLK; 
 
     
       output               HARD_ERR; 
       output               SOFT_ERR; 
 
 
 
       reg                  HARD_ERR; 
       reg                  SOFT_ERR; 
       reg                  rx_header_err_r; 
 
       wire                 soft_err_detect; 
 
 
 
     
     assign soft_err_detect1 = ((ILLEGAL_BTF) & RXDATAVALID_IN);

     always @(posedge USER_CLK)
             rx_header_err_r         <=  `DLY RX_HEADER_ERR;

     assign soft_err_detect2 = (rx_header_err_r);
     assign soft_err_detect  = (soft_err_detect1 | soft_err_detect2);
     
     always @(posedge USER_CLK)
         if(ENABLE_ERR_DETECT & soft_err_detect)
         begin
             SOFT_ERR         <=  `DLY 1'b1;
         end
         else
         begin
             SOFT_ERR         <=  `DLY 1'b0;
         end
 
     
     always @(posedge USER_CLK)
         if(ENABLE_ERR_DETECT)
         begin
             HARD_ERR         <=  `DLY (RX_BUF_ERR | TX_BUF_ERR);
         end
         else
         begin
             HARD_ERR          <=  `DLY    1'b0;
         end
 
 
     
     
     assign HARD_ERR_RESET =   HARD_ERR;
 
 
 endmodule