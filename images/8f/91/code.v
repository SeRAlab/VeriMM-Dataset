module top_module(
    Q      ,
    Q_N    ,
    D      ,
    CLK    ,
    SET_B  ,
    RESET_B
);output Q      ;
    output Q_N    ;
    input  D      ;
    input  CLK    ;
    input  SET_B  ;
    input  RESET_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Replace sky130_fd_sc_ms__dfbbp_1 with a generic D flip-flop implementation
    reg Q;
    always @(posedge CLK or negedge RESET_B or negedge SET_B) begin
        if (~RESET_B)
            Q <= 1'b0;
        else if (~SET_B)
            Q <= 1'b1;
        else
            Q <= D;
    end

    assign Q_N = ~Q;

endmodule