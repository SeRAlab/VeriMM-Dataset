module SR_FF (
    input wire S,
    input wire R,
    input wire clk,
    input wire rst,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else begin
            if (S && !R) begin
                Q <= 1;
            end else if (!S && R) begin
                Q <= 0;
            end
            // If both S and R are low, maintain the previous state
        end
    end
endmodule