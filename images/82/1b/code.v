module top_module(
    X   ,
    A_N ,
    B   ,
    C   ,
    D   
);output X   ;
    input  A_N ;
    input  B   ;
    input  C   ;
    input  D   ;

    reg X_reg;

    always @(A_N or B or C or D) begin
        X_reg <= ~(A_N & B & C & D);
    end

    assign X = X_reg;

endmodule