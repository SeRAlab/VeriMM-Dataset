module top_module(
    input  A1  ,
    input  A2  ,
    input  B1  ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire A1_B1;
    wire A1_B1_A2;
    wire A1_A2_B1;
    wire B1_A2;
    wire B1_A2_A1;
    wire A1_B1_A2_B1;
    
    assign A1_B1 = A1 & B1;
    assign A1_B1_A2 = A1_B1 & A2;
    assign A1_A2_B1 = A1 & A2 & B1;
    assign B1_A2 = B1 & A2;
    assign B1_A2_A1 = B1_A2 & A1;
    assign A1_B1_A2_B1 = A1_B1 & A2 & B1;
    
    assign X = A1_B1_A2 | A1_A2_B1 | B1_A2_A1 | A1_B1_A2_B1;
endmodule