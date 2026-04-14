module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output wire Q_not
);
    assign Q_not = ~Q;

    always @(S or R) begin
        if (S && ~R) begin
            Q <= 1'b1; // Set
        end else if (~S && R) begin
            Q <= 1'b0; // Reset
        end else if (~S && ~R) begin
            // Maintain state
            Q <= Q;  
        end else begin
            // Invalid state (S = 1, R = 1)
            Q <= Q;  
        end
    end
endmodule