module M65C02_MPCv4 #(
    parameter pAddrWidth = 10,          
    parameter pRst_Addrs = 0            
)(
    input   Rst,                        
    input   Clk,                        
    input   Wait,                       
    output  reg [2:0] MC,               
    input   [3:0] I,                    
    input   [3:0] T,                    
    input   [2:0] MW,                   
    input   [(pAddrWidth-1):0] BA,      
    output  [1:0] Via,                  
    output  [(pAddrWidth-1):0] MA       
);
localparam pRTS  =  0;  
localparam pBSR  =  1;  
localparam pFTCH =  2;  
localparam pBMW  =  3;  
localparam pBRV0 =  4;  
localparam pBRV1 =  5;  
localparam pBRV2 =  6;  
localparam pBRV3 =  7;  
localparam pBTH0 =  8;  
localparam pBTH1 =  9;  
localparam pBTH2 = 10;  
localparam pBTH3 = 11;  
localparam pBTL0 = 12;  
localparam pBTL1 = 13;  
localparam pBTL2 = 14;  
localparam pBTL3 = 15;  
reg     MPC_En;                             
wire    [(pAddrWidth - 1):0] Next;          
reg     [(pAddrWidth - 1):0] PC_In;         
reg     [(pAddrWidth - 1):0] PC;            
reg     [(pAddrWidth - 1):0] A;             
reg     dRst;                               
wire    MPC_Rst;                            
always @(posedge Clk)
begin
    if(Rst)
        dRst <= #1 1;
    else
        dRst <= #1 0;
end
assign MPC_Rst = (Rst | dRst);
always @(posedge Clk)
begin
    if(Rst)
        MC <= #1 6;
    else
        case(MC)
            4 : MC <= #1 6;                 
            6 : MC <= #1 7;                 
            7 : MC <= #1 5;                 
            5 : MC <= #1 ((Wait) ? 0 : 4);  
            0 : MC <= #1 2;                 
            2 : MC <= #1 3;                 
            3 : MC <= #1 1;                 
            1 : MC <= #1 ((Wait) ? 0 : 4);  
        endcase
end
always @(posedge Clk) MPC_En <= #1 ((Rst) ? 0 : (~Wait & (MC[1:0] == 1)));
always @(posedge Clk)
begin
    if(MPC_Rst)
        A <= #1 0;
    else if(MPC_En)
        if(I == pBSR)
            A <= #1 Next;
        else if(I == pRTS)
            A <= #1 {pAddrWidth{1'b0}};
end
assign Next = PC + 1;
assign Via = {((I == pBRV2) | (I == pBRV3)), ((I == pBRV3) | (I == pBRV1))};       
always @(*)
begin
    case({MPC_Rst, I})
        pRTS    : PC_In <=  A;
        pBSR    : PC_In <=  BA;
        pFTCH   : PC_In <=  Next;
        pBMW    : PC_In <=  {BA[(pAddrWidth - 1):3], MW};
        pBRV0   : PC_In <=  BA;
        pBRV1   : PC_In <=  BA;
        pBRV2   : PC_In <=  BA;
        pBRV3   : PC_In <=  BA;
        pBTH0   : PC_In <=  (T[0] ? BA   : Next);
        pBTH1   : PC_In <=  (T[1] ? BA   : Next);
        pBTH2   : PC_In <=  (T[2] ? BA   : Next);
        pBTH3   : PC_In <=  (T[3] ? BA   : Next);
        pBTL0   : PC_In <=  (T[0] ? Next : BA  );
        pBTL1   : PC_In <=  (T[1] ? Next : BA  );
        pBTL2   : PC_In <=  (T[2] ? Next : BA  );
        pBTL3   : PC_In <=  (T[3] ? Next : BA  );
        default : PC_In <=  pRst_Addrs;
    endcase
end
always @(posedge Clk)
begin
    if(MPC_Rst)
        PC <= #1 pRst_Addrs;
    else if(MPC_En)
        PC <= #1 PC_In;
end
assign MA = PC_In;
endmodule