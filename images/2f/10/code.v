module SR_latch (
    input wire S,
    input wire R,
    output reg Q
);
    always @(posedge S or posedge R) begin
        if (R) begin
            Q <= 0; // Reset condition
        end else if (S) begin
            Q <= 1; // Set condition
        end
    end
endmodule