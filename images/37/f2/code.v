module sr_latch(
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_not
);
    
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1;
            Q_not <= 0;
        end else if (!S && R) begin
            Q <= 0;
            Q_not <= 1;
        end // keep the current state if both S and R are low
    end
endmodule