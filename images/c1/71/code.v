module Phy_int (
Reset               ,
MAC_rx_clk          ,
MAC_tx_clk          ,
MCrs_dv             ,
MRxD                ,
MRxErr              ,
MTxD                ,
MTxEn               ,
MCRS                ,
Tx_er               ,
Tx_en               ,
Txd                 ,
Rx_er               ,
Rx_dv               ,
Rxd                 ,
Crs                 ,
Col                 ,
Line_loop_en        ,
Speed               
);
input           Reset               ;
input           MAC_rx_clk          ;
input           MAC_tx_clk          ;
output          MCrs_dv             ;       
output  [7:0]   MRxD                ;       
output          MRxErr              ;       
input   [7:0]   MTxD                ;
input           MTxEn               ;   
output          MCRS                ;
output          Tx_er               ;
output          Tx_en               ;
output  [7:0]   Txd                 ;
input           Rx_er               ;
input           Rx_dv               ;
input   [7:0]   Rxd                 ;
input           Crs                 ;
input           Col                 ;
input           Line_loop_en        ;
input   [2:0]   Speed               ;
reg     [7:0]   MTxD_dl1            ;
reg             MTxEn_dl1           ;
reg             Tx_odd_data_ptr     ;  
reg             Rx_odd_data_ptr     ;
reg             Tx_en               ;
reg     [7:0]   Txd                 ;
reg             MCrs_dv             ;
reg     [7:0]   MRxD                ;
reg             Rx_er_dl1           ;
reg             Rx_dv_dl1           ;
reg             Rx_dv_dl2           ;
reg     [7:0]   Rxd_dl1             ;
reg     [7:0]   Rxd_dl2             ;
reg             Crs_dl1             ;
reg             Col_dl1             ;
always @ (posedge MAC_tx_clk or posedge Reset)
    if (Reset)
        begin
        MTxD_dl1            <=0;
        MTxEn_dl1           <=0;
        end  
    else
        begin
        MTxD_dl1            <=MTxD  ;
        MTxEn_dl1           <=MTxEn ;
        end 
always @ (posedge MAC_tx_clk or posedge Reset)
    if (Reset)   
        Tx_odd_data_ptr     <=0;
    else if (!MTxD_dl1)
        Tx_odd_data_ptr     <=0;
    else 
        Tx_odd_data_ptr     <=!Tx_odd_data_ptr;
always @ (posedge MAC_tx_clk or posedge Reset)
    if (Reset)  
        Txd                 <=0;
    else if(Speed[2]&&MTxEn_dl1)
        Txd                 <=MTxD_dl1;
    else if(MTxEn_dl1&&!Tx_odd_data_ptr)
        Txd                 <={4'b0,MTxD_dl1[3:0]};
    else if(MTxEn_dl1&&Tx_odd_data_ptr)
        Txd                 <={4'b0,MTxD_dl1[7:4]};
    else
        Txd                 <=0;
always @ (posedge MAC_tx_clk or posedge Reset)
    if (Reset)  
        Tx_en               <=0;
    else if(MTxEn_dl1)
        Tx_en               <=1;    
    else
        Tx_en               <=0;
assign Tx_er=0;
always @ (posedge MAC_rx_clk or posedge Reset)
    if (Reset)  
        begin
        Rx_er_dl1           <=0;
        Rx_dv_dl1           <=0;
        Rx_dv_dl2           <=0 ;
        Rxd_dl1             <=0;
        Rxd_dl2             <=0;
        Crs_dl1             <=0;
        Col_dl1             <=0;
        end
    else
        begin
        Rx_er_dl1           <=Rx_er     ;
        Rx_dv_dl1           <=Rx_dv     ;
        Rx_dv_dl2           <=Rx_dv_dl1 ;
        Rxd_dl1             <=Rxd       ;
        Rxd_dl2             <=Rxd_dl1   ;
        Crs_dl1             <=Crs       ;
        Col_dl1             <=Col       ;
        end     
assign MRxErr   =Rx_er_dl1      ;
assign MCRS     =Crs_dl1        ;
always @ (posedge MAC_rx_clk or posedge Reset)
    if (Reset)  
        MCrs_dv         <=0;
    else if(Line_loop_en)
        MCrs_dv         <=Tx_en;
    else if(Rx_dv_dl2)
        MCrs_dv         <=1;
    else
        MCrs_dv         <=0;
always @ (posedge MAC_rx_clk or posedge Reset)
    if (Reset)   
        Rx_odd_data_ptr     <=0;
    else if (!Rx_dv_dl1)
        Rx_odd_data_ptr     <=0;
    else 
        Rx_odd_data_ptr     <=!Rx_odd_data_ptr;
always @ (posedge MAC_rx_clk or posedge Reset)
    if (Reset)  
        MRxD            <=0;
    else if(Line_loop_en)
        MRxD            <=Txd;
    else if(Speed[2]&&Rx_dv_dl2)
        MRxD            <=Rxd_dl2;
    else if(Rx_dv_dl1&&Rx_odd_data_ptr)
        MRxD            <={Rxd_dl1[3:0],Rxd_dl2[3:0]};
endmodule