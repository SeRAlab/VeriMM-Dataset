module M65C02_MPC #(
    parameter pAddrWidth = 10,          
    parameter pRst_Addrs = 0            
)(
    input   Rst,                        
    input   Clk,                        
    input   [3:0] I,                    
    input   [3:0] T,                    
    input   [2:0] MW,                   
    input   [(pAddrWidth-1):0] BA,      
    output  [1:0] Via,                  
    input   En,                         
    input   Rdy,                        
    input   PLS,                        
    output  reg [(pAddrWidth-1):0] MA   
);
localparam RTS  =  0;   
localparam BSR  =  1;   
localparam FTCH =  2;   
localparam BMW  =  3;   
localparam BRV0 =  4;   
localparam BRV1 =  5;   
localparam BRV2 =  6;   
localparam BRV3 =  7;   
localparam BTH0 =  8;   
localparam BTH1 =  9;   
localparam BTH2 = 10;   
localparam BTH3 = 11;   
localparam BTL0 = 12;   
localparam BTL1 = 13;   
localparam BTL2 = 14;   
localparam BTL3 = 15;   
wire    [(pAddrWidth - 1):0] Next;        
reg     [(pAddrWidth - 1):0] PC_In;       
reg     [(pAddrWidth - 1):0] PC;          
reg     [(pAddrWidth - 1):0] A, B, C, D;  
reg     dRst;                             
wire    MPC_Rst;                          
always @(posedge Clk)
begin
    if(Rst)
        dRst <= #1 1;
    else
        dRst <= #1 0;
end
assign MPC_Rst = ((PLS) ? (Rst | dRst) : Rst);
always @(posedge Clk)
begin
    if(MPC_Rst)
        {D, C, B, A} <= #1 0;
    else if(I == BSR)
        {D, C, B, A} <= #1 {C, B, A, Next};
    else if(I == RTS)
        {D, C, B, A} <= #1 {{pAddrWidth{1'b0}}, D, C, B};
end
assign Next = PC + 1;
assign Via = {((I == BRV2) | (I == BRV3)), ((I == BRV3) | (I == BRV1))};       
always @(*)
begin
    case({MPC_Rst, I})
        RTS     : PC_In <=  A;
        BSR     : PC_In <=  BA;
        FTCH    : PC_In <=  Next;
        BMW     : PC_In <=  {BA[(pAddrWidth - 1):3], MW};
        BRV0    : PC_In <=  BA;
        BRV1    : PC_In <=  BA;
        BRV2    : PC_In <=  BA;
        BRV3    : PC_In <=  BA;
        BTH0    : PC_In <=  (T[0] ? BA   : Next);
        BTH1    : PC_In <=  (T[1] ? BA   : Next);
        BTH2    : PC_In <=  (T[2] ? BA   : Next);
        BTH3    : PC_In <=  (T[3] ? BA   : Next);
        BTL0    : PC_In <=  (T[0] ? Next : BA  );
        BTL1    : PC_In <=  (T[1] ? Next : BA  );
        BTL2    : PC_In <=  (T[2] ? Next : BA  );
        BTL3    : PC_In <=  (T[3] ? Next : BA  );
        default : PC_In <=  pRst_Addrs;
    endcase
end
always @(posedge Clk)
begin
    if(MPC_Rst)
        PC <= #1 pRst_Addrs;
    else
        PC <= #1 ((En) ? ((Rdy) ? PC_In : PC) : PC_In);
end
always @(*)
begin
    MA <= ((PLS) ? ((En) ? ((Rdy) ? PC_In : PC) : PC_In) : PC);
end
endmodule