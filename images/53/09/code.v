module top_module(
    Q    ,
    CLK  ,
    D    ,
    SCD  ,
    SCE  ,
    SET_B
);output Q    ;
    input  CLK  ;
    input  D    ;
    input  SCD  ;
    input  SCE  ;
    input  SET_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg Q;

    always @(posedge CLK or negedge SCD or negedge SCE or negedge SET_B) begin
        if (SCD == 0) begin
            Q <= 0;
        end else if (SCE == 0) begin
            Q <= 1;
        end else if (SET_B == 0) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule