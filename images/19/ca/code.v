module portfolio_optimizer (
    input [7:0] return_A,
    input [7:0] risk_A,
    input [7:0] return_B,
    input [7:0] risk_B,
    output reg decision_A
);
    parameter RISK_FREE_RATE = 8'd2;

    wire [15:0] sharpe_A;
    wire [15:0] sharpe_B;
    
    assign sharpe_A = (return_A - RISK_FREE_RATE) / risk_A;
    assign sharpe_B = (return_B - RISK_FREE_RATE) / risk_B;

    always @(*) begin
        if (sharpe_A > sharpe_B)
            decision_A = 1;
        else
            decision_A = 0;
    end
endmodule