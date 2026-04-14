module portfolio_optimizer(
    input [15:0] return_a,   // expected return of portfolio A
    input [15:0] risk_a,     // risk of portfolio A
    input [15:0] return_b,   // expected return of portfolio B
    input [15:0] risk_b,     // risk of portfolio B
    output reg choose_a       // output signal to choose portfolio A
);
    always @(*) begin
        if ((return_a / risk_a) > (return_b / risk_b))
            choose_a = 1; // Choose portfolio A
        else
            choose_a = 0; // Choose portfolio B
    end
endmodule