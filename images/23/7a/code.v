module sr_latch(
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_N
);
    
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (!S && R) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end
    end
endmodule