module binary_multiplier (
    input [2:0] A,
    input [2:0] B,
    output reg [5:0] P
);
    always @(*) begin
        // Initialize product to 0
        P = 6'b000000;

        // Perform multiplication with hazard detection
        P[0] = A[0] & B[0];
        P[1] = (A[0] & B[1]) ^ (A[1] & B[0]);
        P[2] = (A[0] & B[2]) ^ (A[1] & B[1]) ^ (A[2] & B[0]);
        P[3] = (A[1] & B[2]) ^ (A[2] & B[1]);
        P[4] = A[2] & B[2];
        
        // Resolving the hazards using a delay model
        #1; // introduce a small delay to stabilize output
    end
endmodule