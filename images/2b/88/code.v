module SR_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output wire Q_n
);
    assign Q_n = ~Q;

    always @(posedge clk) begin
        if (S && !R) 
            Q <= 1;
        else if (!S && R) 
            Q <= 0;
        // Hold state when S = 0 and R = 0
        // Undefined state when S = 1 and R = 1, holding previous state
    end
endmodule