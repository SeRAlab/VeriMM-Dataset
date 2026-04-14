module top_module(
    Q    ,
    Q_N  ,
    CLK  ,
    D    ,
    S    ,
    R    ,
    ASYNC,
    EN
);// Module ports
    output reg [3:0] Q    ;
    output reg [3:0] Q_N  ;
    input  CLK  ;
    input  D    ;
    input  S    ;
    input  R    ;
    input  ASYNC;
    input  EN   ;

    // Local signals
    reg [3:0] buf_Q        ;
    wire set          ;
    wire mux_out      ;

    //                                  Name       Output   Other arguments
    not                                 not0      (set    , ASYNC                                  );
    assign mux_out = set ? buf_Q[3] : S; // Mux implementation using a simple assign
    always @ (posedge CLK or posedge R) begin
        if (R) begin
            buf_Q <= 4'b0; // Asynchronous reset to 0
        end else if (EN) begin
            buf_Q <= {buf_Q[2:0], D};
        end
    end

    assign Q = buf_Q;
    assign Q_N = ~buf_Q;

endmodule