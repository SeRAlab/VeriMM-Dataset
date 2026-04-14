module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    A4  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  A4  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire [1:0] select;
    assign select = {B1, ~B1};
    
    wire [3:0] mux_out; // Fixed size to 4 bits
    assign mux_out[0] = A1;
    assign mux_out[1] = A2;
    assign mux_out[2] = A3;
    assign mux_out[3] = A4;
    
    assign X = mux_out[select]; // This also needs to be change since select is 2 bits

endmodule