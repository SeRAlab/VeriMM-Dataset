module SPIxIF (
    input   Rst,                
    input   Clk,                
    input   LSB,                
    input   [1:0] Mode,         
    input   [2:0] Rate,         
    input   DAV,                
    output  reg FRE,            
    input   [8:0] TD,           
    output  reg FWE,            
    output  [7:0] RD,           
    output  reg SS,             
    output  reg SCK,            
    output  MOSI,               
    input   MISO                
);
reg     Dir;                                
reg     SCK_Lvl, SCK_Inv, COS_SCK_Lvl;      
reg     [2:0] rRate;                        
reg     [6:0] CE_Cntr;                      
wire    CE;                                 
wire    CE_SCK, Rst_SCK;                    
reg     Ld;                                 
wire    CE_OSR, CE_ISR;                     
reg     [7:0] OSR, ISR;                     
reg     RdEn;                               
reg     [2:0] BitCnt;                       
wire    TC_BitCnt;                          
always @(posedge Clk)
begin
    if(Rst)
        Dir <= #1 0;            
    else if(~SS)
        Dir <= #1 LSB;          
end
always @(posedge Clk)
begin
    if(Rst) begin
        SCK_Inv <= #1 0;
        SCK_Lvl <= #1 0;
    end else if(~SS) begin
        SCK_Inv <= #1 ^Mode;    
        SCK_Lvl <= #1 Mode[0];  
    end
end
always @(posedge Clk)
begin
    if(Rst)
        COS_SCK_Lvl <= #1 0;
    else
        COS_SCK_Lvl <= #1 ((~SS) ? (SCK_Lvl ^ Mode[0]) : 0);
end
always @(posedge Clk)
begin
    if(Rst)
        rRate <= #1 ~0;             
    else if(~SS)
        rRate <= #1 Rate;
end
always @(posedge Clk)
begin
    if(Rst)
        Ld <= #1 0;
    else if(~SS)
        Ld <= #1 DAV & ~Ld;
    else if(Ld)
        Ld <= #1 0;
end
always @(posedge Clk)
begin
    if(Rst)
        CE_Cntr <= #1 ~0;
    else if(CE)
        case(rRate)
            3'b000  : CE_Cntr <= #1 0;
            3'b001  : CE_Cntr <= #1 1;
            3'b010  : CE_Cntr <= #1 3;
            3'b011  : CE_Cntr <= #1 7;
            3'b100  : CE_Cntr <= #1 15;
            3'b101  : CE_Cntr <= #1 31;
            3'b110  : CE_Cntr <= #1 63;
            3'b111  : CE_Cntr <= #1 127;
        endcase
    else if(SS)
        CE_Cntr <= #1 (CE_Cntr - 1);
end
assign CE = (Ld | (~|CE_Cntr));
assign CE_SCK  = CE & SS; 
assign Rst_SCK = Rst | Ld | (COS_SCK_Lvl & ~SS) | (TC_BitCnt & CE_OSR & ~DAV);
always @(posedge Clk)
begin
    if(Rst_SCK) 
        #1 SCK <= (Ld ? SCK_Inv : SCK_Lvl);
    else if(CE_SCK)
        #1 SCK <= ~SCK;
end
assign CE_OSR = CE_SCK & (SCK_Inv ^ SCK);   
assign Ld_OSR = Ld | (TC_BitCnt & CE_OSR);   
always @(posedge Clk)
begin
    if(Rst)
        OSR <= #1 0;
    else if(Ld_OSR)
        OSR <= #1 TD;
    else if(CE_OSR)
        OSR <= #1 ((Dir) ? {SCK_Lvl, OSR[7:1]} : {OSR[6:0], SCK_Lvl});
end
assign MOSI = SS & ((Dir) ? OSR[0] : OSR[7]);
assign CE_ISR = CE_SCK & (SCK_Inv ^ ~SCK);   
always @(posedge Clk)
begin
    if(Rst)
        ISR <= #1 0;
    else if(Ld)
        ISR <= #1 0;
    else if(CE_ISR)
        ISR <= #1 ((Dir) ? {MISO, ISR[7:1]} : {ISR[6:0], MISO});
end
assign CE_BitCnt  = CE_OSR & SS;
assign Rst_BitCnt = Rst | Ld | (TC_BitCnt & CE_OSR);
always @(posedge Clk)
begin
    if(Rst_BitCnt)
        BitCnt <= #1 7;
    else if(CE_BitCnt)
        BitCnt <= #1 (BitCnt - 1);
end
assign TC_BitCnt = ~|BitCnt;
always @(posedge Clk)
begin
    if(Rst)
        SS <= #1 0;
    else if(Ld_OSR)
        SS <= #1 DAV;
end
always @(posedge Clk)
begin
    if(Rst)
        RdEn <= #1 0;
    else if(Ld_OSR)
        RdEn <= #1 ((DAV) ? TD[8] : 0);
end
always @(posedge Clk)
begin
    if(Rst)
        FRE <= #1 0;
    else
        FRE <= #1 (Ld | (DAV & (TC_BitCnt & CE_OSR)));
end
always @(posedge Clk)
begin
    if(Rst)
        FWE <= #1 0;
    else
        FWE <= #1 (RdEn & (TC_BitCnt & CE_ISR));
end
assign RD = ISR;
endmodule