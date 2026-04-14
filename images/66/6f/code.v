module top_module(
    iClock      ,
    iReset      ,
    oPopSignal  ,
    iEmpty      ,
    oValid      ,
    iReady
);input   iClock      ;
    input   iReset      ;
    output  oPopSignal  ;
    input   iEmpty      ;
    output  oValid      ;
    input   iReady      ;

    reg     rValid      ;
    
    assign  oPopSignal  = (!iEmpty && (!rValid || iReady));
    assign  oValid      = rValid;
    
    always @ (posedge iClock)
        if (iReset)
            rValid <= 1'b0;
        else
            if ((!rValid || iReady))
                rValid <= oPopSignal;

endmodule