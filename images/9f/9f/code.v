module top_module(
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    SET_B,
    RESET_B
);output Q    ;
    output Q_N  ;
    input  CLK  ;
    input  D    ;
    input  SET_B;
    input  RESET_B;

    // Declare internal signal
    reg Q_int;

    // Implement flip-flop with set and reset functionality
    always @(posedge CLK) begin
        if (SET_B == 0) begin
            Q_int <= 1;
        end else if (RESET_B == 0) begin
            Q_int <= 0;
        end else begin
            Q_int <= D;
        end
    end

    // Assign output signals
    assign Q = Q_int;
    assign Q_N = ~Q_int;

endmodule