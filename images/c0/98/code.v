module SSPx_Slv(
    input   Rst,            
    input   SSEL,           
    input   SCK,            
    input   MOSI,           
    output  reg MISO,       
    output  reg [2:0] RA,   
    output  reg WnR,        
    output  En,             
    output  reg EOC,        
    output  reg [11:0] DI,  
    input   [11:0] DO,      
    output  reg [3:0] BC    
);
    reg     [15:1] RDI; 
    reg     [11:0] rDO; 
    reg     SSP_Rst;
assign Rst_SSP = (Rst | ~SSEL);
always @(posedge SCK or posedge Rst_SSP)
begin
    if(Rst_SSP)
        SSP_Rst <= #1 ~0;
    else
        SSP_Rst <= #1  0;
end
always @(negedge SCK or posedge SSP_Rst)
begin
    if(SSP_Rst)
        BC <= #1 4'd0;
    else
        BC <= #1 (BC + 1);
end
always @(negedge SCK or posedge SSP_Rst)
begin
    if(SSP_Rst)
        EOC <= #1 1'b0;
    else
        EOC <= #1 (BC == 14);
end
assign En = BC[3] | BC[2];
always @(posedge SCK or posedge Rst_SSP)
begin
    if(Rst_SSP)
        RDI <= #1 15'b0;
    else
        case(BC)
            4'b0000 : RDI[15] <= #1 MOSI;
            4'b0001 : RDI[14] <= #1 MOSI;
            4'b0010 : RDI[13] <= #1 MOSI;
            4'b0011 : RDI[12] <= #1 MOSI;
            4'b0100 : RDI[11] <= #1 MOSI;
            4'b0101 : RDI[10] <= #1 MOSI;
            4'b0110 : RDI[ 9] <= #1 MOSI;
            4'b0111 : RDI[ 8] <= #1 MOSI;
            4'b1000 : RDI[ 7] <= #1 MOSI;
            4'b1001 : RDI[ 6] <= #1 MOSI;
            4'b1010 : RDI[ 5] <= #1 MOSI;
            4'b1011 : RDI[ 4] <= #1 MOSI;
            4'b1100 : RDI[ 3] <= #1 MOSI;
            4'b1101 : RDI[ 2] <= #1 MOSI;
            4'b1110 : RDI[ 1] <= #1 MOSI;
            default : RDI <= #1 RDI;
        endcase
end
assign CE_RA = (BC == 2);
always @(negedge SCK or posedge Rst_SSP)
begin
    if(Rst_SSP)
        RA <= #1 0;
    else if(CE_RA)
        RA <= #1 RDI[15:13];
end
assign CE_WnR = (BC == 3);
always @(negedge SCK or posedge Rst_SSP)
begin
    if(Rst_SSP)
        WnR <= #1 0;
    else if(EOC)
        WnR <= #1 0;
    else if(CE_WnR)
        WnR <= #1 RDI[12];
end
always @(*) DI <= {RDI[11:1], MOSI};
always @(negedge SCK or posedge Rst)
begin
    if(Rst)
        rDO <= #1 0;
    else if(BC == 3)
        rDO <= #1 DO;
end        
always @(*)
begin
    case(BC)
        4'b0000 :   MISO <= MOSI;
        4'b0001 :   MISO <= MOSI;
        4'b0010 :   MISO <= MOSI;
        4'b0011 :   MISO <= MOSI;
        4'b0100 :   MISO <= rDO[11];
        4'b0101 :   MISO <= rDO[10];
        4'b0110 :   MISO <= rDO[ 9];
        4'b0111 :   MISO <= rDO[ 8];
        4'b1000 :   MISO <= rDO[ 7];
        4'b1001 :   MISO <= rDO[ 6];
        4'b1010 :   MISO <= rDO[ 5];
        4'b1011 :   MISO <= rDO[ 4];
        4'b1100 :   MISO <= rDO[ 3];
        4'b1101 :   MISO <= rDO[ 2];
        4'b1110 :   MISO <= rDO[ 1];
        4'b1111 :   MISO <= rDO[ 0];
    endcase
end
endmodule