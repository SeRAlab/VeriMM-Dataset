module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @(S, R) begin
        if (S && R) begin
            // Invalid state
            Q <= 1'b0; // or could also be a don't care
            Qn <= 1'b1; // or could also be a don't care
        end else if (S && !R) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (!S && R) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end
        // If both are low, hold the state
    end
endmodule