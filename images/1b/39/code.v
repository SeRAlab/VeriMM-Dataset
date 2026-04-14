module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    
    always @(S or R) begin
        if (S && R) begin
            Q <= 1'bx; // Invalid state
            Qn <= 1'bx; // Invalid state
        end else if (S) begin
            Q <= 1'b1; // Set state
            Qn <= 1'b0;
        end else if (R) begin
            Q <= 1'b0; // Reset state
            Qn <= 1'b1;
        end
    end
endmodule