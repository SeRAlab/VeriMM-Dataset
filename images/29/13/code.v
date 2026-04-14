module FixedPointMultiplier (
    input signed [7:0] A,
    input signed [7:0] B,
    output reg signed [15:0] Result
);

    always @(*) begin
        // Perform multiplication
        Result = A * B;

        // Saturate to max/min values if overflow occurs
        if (Result > 16'sh7FFF) begin
            Result = 16'sh7FFF; // Max value for Q1.15
        end else if (Result < 16'sh8000) begin
            Result = 16'sh8000; // Min value for Q1.15
        end
    end
endmodule