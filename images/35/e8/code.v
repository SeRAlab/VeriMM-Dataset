module hazard_detection(
    input wire A,
    input wire B,
    output reg Y
);
    reg A_prev, B_prev;

    always @(A or B) begin
        // Detect hazard condition
        if ((A != A_prev) || (B != B_prev)) begin
            // Hold stable output for one cycle
            Y <= Y; // Hold previous value
        end else begin
            Y <= A & B; // Normal output
        end
        // Update previous values
        A_prev <= A;
        B_prev <= B;
    end
endmodule