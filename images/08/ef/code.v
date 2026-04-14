module phase_frequency_detector (
    input wire clk,        // Reference clock
    input wire A,         // Input clock A
    input wire B,         // Input clock B
    output reg UP,        // UP output
    output reg DOWN       // DOWN output
);

    reg A_prev, B_prev;

    always @(posedge clk) begin
        A_prev <= A;
        B_prev <= B;
        
        // Reset outputs
        UP <= 1'b0;
        DOWN <= 1'b0;

        if (A_prev && !A && !B_prev && B) begin
            UP <= 1'b1;   // A leads B
        end else if (!A_prev && A && B_prev && !B) begin
            DOWN <= 1'b1; // B leads A
        end
    end
endmodule