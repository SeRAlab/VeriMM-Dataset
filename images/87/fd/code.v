module top_module(
    X ,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1
);output X ;
    input  A0;
    input  A1;
    input  A2;
    input  A3;
    input  S0;
    input  S1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [3:0] data;
    
    assign data[0] = A0;
    assign data[1] = A1;
    assign data[2] = A2;
    assign data[3] = A3;
    
    assign X = (S1 & S0 == 2'b00) ? data[0] :
               (S1 & S0 == 2'b01) ? data[1] :
               (S1 & S0 == 2'b10) ? data[2] :
               (S1 & S0 == 2'b11) ? data[3] : 1'bx;

endmodule