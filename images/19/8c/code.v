module hazard_detection (
    input [3:0] A,
    input [3:0] B,
    output reg hazard
);
    always @(*) begin
        hazard = 0; // Initialize hazard to 0
        if (A[0] == B[0] || A[1] == B[1] || A[2] == B[2] || A[3] == B[3]) begin
            hazard = 1; // Hazard detected
        end
    end
endmodule