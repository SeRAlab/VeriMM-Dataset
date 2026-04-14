module top_module(
    //# {{data|Data Signals}}
    input  A,
    input  B,
    input  C,
    input  D,
    output reg X,  // Change output to reg to allow assignment in always block

    //# {{control|Control Signals}}
    input  S0,
    input  S1
);always @(*) begin
        if (S1 == 0 && S0 == 0) begin
            X = A;
        end else if (S1 == 0 && S0 == 1) begin
            X = B;
        end else if (S1 == 1 && S0 == 0) begin
            X = C;
        end else if (S1 == 1 && S0 == 1) begin
            X = D;
        end
    end

endmodule