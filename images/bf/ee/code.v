module P16C5x_ALU (
    input   Rst,
    input   Clk,
    input   CE,
    input   [11:0] ALU_Op,              
    input   WE_PSW,                     
    input   [7:0] DI,                   
    input   [7:0] KI,                   
    output  reg [7:0] DO,               
    output  Z_Tst,                      
    output  g,                          
    output  reg [7:0] W,                
    output  reg Z,                      
    output  reg DC,                     
    output  reg C                       
);
wire    [7:0] A, B, Y;
wire    [7:0] X;
wire    C3, C7;
wire    [1:0] LU_Op;
reg     [7:0] V;
wire    [1:0] S_Sel;
reg     [7:0] S;
wire    [2:0] Bit;
reg     [7:0] Msk;
wire    [7:0] U;
wire    [7:0] T;
wire    [1:0] D_Sel;
assign C_In  = ALU_Op[0];  
assign B_Inv = ALU_Op[1];  
assign B_Sel = ALU_Op[2];  
assign A_Sel = ALU_Op[3];  
assign A = ((A_Sel) ? KI : DI);
assign B = ((B_Sel) ?  W : 0 );
assign Y = ((B_Inv) ? ~B : B );
assign {C3, X[3:0]} = A[3:0] + Y[3:0] + C_In;
assign {C7, X[7:4]} = A[7:4] + Y[7:4] + C3;
assign LU_Op = ALU_Op[1:0];
always @(*)
begin
    case (LU_Op)
        2'b00 : V <= ~A;
        2'b01 : V <=  A | B;
        2'b10 : V <=  A & B;
        2'b11 : V <=  A ^ B;
    endcase
end
assign S_Sel = ALU_Op[1:0];
always @(*)
begin
    case (S_Sel)
        2'b00 : S <= B;                  
        2'b01 : S <= {A[3:0], A[7:4]};   
        2'b10 : S <= {C, A[7:1]};        
        2'b11 : S <= {A[6:0], C};        
    endcase
end
assign Bit = ALU_Op[2:0];
assign Set = ALU_Op[3];
assign Tst = ALU_Op[8];
always @(*)
begin
    case(Bit)
        3'b000  : Msk <= 8'b0000_0001;
        3'b001  : Msk <= 8'b0000_0010;
        3'b010  : Msk <= 8'b0000_0100;
        3'b011  : Msk <= 8'b0000_1000;
        3'b100  : Msk <= 8'b0001_0000;
        3'b101  : Msk <= 8'b0010_0000;
        3'b110  : Msk <= 8'b0100_0000;
        3'b111  : Msk <= 8'b1000_0000;
    endcase
end
assign U = ((Set) ? (DI | Msk) : (DI & ~Msk));
assign T = DI & Msk;
assign g = ((Tst) ? ((Set) ? |T : ~|T) 
                  : 1'b0              );
assign D_Sel = ALU_Op[7:6];
always @(posedge Clk)
begin
    if(Rst)
        DO <= #1 0;
    else
        case (D_Sel)
            2'b00 : DO <= #1 X;     
            2'b01 : DO <= #1 V;     
            2'b10 : DO <= #1 S;     
            2'b11 : DO <= #1 U;     
        endcase
end
assign WE_W = ALU_Op[9];
always @(posedge Clk)
begin
    if(Rst)
        W <= #1 8'b0;
    else if(CE)
        W <= #1 ((WE_W) ? DO : W);
end
assign Z_Sel = ALU_Op[5];
assign Z_Tst = ~|DO;
always @(posedge Clk)
begin
    if(Rst)
        Z <= #1 1'b0;
    else if(CE)
        Z <= #1 ((Z_Sel) ? Z_Tst 
                         : ((WE_PSW) ? DO[2] : Z));
end
assign DC_Sel = ALU_Op[5] & ALU_Op[4];
always @(posedge Clk)
begin
    if(Rst)
        DC <= #1 1'b0;
    else if(CE)
        DC <= #1 ((DC_Sel) ? C3 
                           : ((WE_PSW) ? DO[1] : DC));
end
assign C_Sel = ALU_Op[4];
assign S_Dir = ALU_Op[1] & ALU_Op[0];
assign C_Drv = ((~ALU_Op[7] & ~ALU_Op[6]) ? C7
                                          : ((S_Dir) ? A[7] : A[0]));
always @(posedge Clk)
begin
    if(Rst)
        C <= #1 1'b0;
    else if(CE)
        C <= #1 ((C_Sel) ? C_Drv 
                         : ((WE_PSW) ? DO[0] : C));
end
endmodule