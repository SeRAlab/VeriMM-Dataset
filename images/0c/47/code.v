module hazard_detection(
    input A,
    input B,
    input C,
    output reg hazard_detected,
    output reg F
);
    always @(*) begin
        // Example function F = A and B or not C
        F = (A & B) | ~C;
        
        // Hazard detection logic
        if ((A & B) & (~C)) // Simple condition for this example
            hazard_detected = 1;
        else
            hazard_detected = 0;
    end
endmodule