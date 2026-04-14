module top_module(
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    SCD  ,
    SCE  ,
    SET_B,
    VPWR ,
    VGND 
);// Module ports
    output Q    ;
    output Q_N  ;
    input  CLK  ;
    input  D    ;
    input  SCD  ;
    input  SCE  ;
    input  SET_B;
    input  VPWR ;
    input  VGND ;

    // Local signals
    reg Q;
    wire Q_N;

    // Synchronous clear
    always @(posedge CLK) begin
        if (SCD) begin
            Q <= 0;
        end
    end

    // Synchronous set
    always @(posedge CLK) begin
        if (SCE) begin
            Q <= 1;
        end
    end

    // Asynchronous set
    always @(SET_B) begin
        if (!SET_B) begin
            Q <= 1;
        end
    end

    // Output Q_N
    assign Q_N = ~Q;

endmodule