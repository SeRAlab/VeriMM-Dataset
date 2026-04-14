module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    C1
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  C1  ;

    wire temp1, temp2, temp3;

    assign temp1 = (A1 & A2 & A3);
    assign temp2 = (~B1 & C1);
    assign temp3 = (B1 & ~C1);

    assign Y = (temp1 | temp2 | temp3);

    // Instantiate the correct module if available
    // Uncomment the following line and update the module name if the correct module is known
    // your_module_name base (
    //     .Y(Y),
    //     .A1(A1),
    //     .A2(A2),
    //     .A3(A3),
    //     .B1(B1),
    //     .C1(C1),
    //     .VPWR(1'b0),
    //     .VGND(1'b0),
    //     .VPB(1'b0),
    //     .VNB(1'b0)
    // );

endmodule