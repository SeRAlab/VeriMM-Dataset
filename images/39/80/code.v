module SR_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1;
            Qn <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Qn <= 1;
        end
        // If both S and R are low, maintain previous state
    end
endmodule