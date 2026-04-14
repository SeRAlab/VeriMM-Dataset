module phase_detector(
    input A,
    input B,
    output reg [1:0] phase_diff
);
    always @(*) begin
        if (A == B)
            phase_diff = 2'b00; // in phase
        else if (A > B)
            phase_diff = 2'b01; // A leads B
        else
            phase_diff = 2'b10; // A lags B
    end
endmodule