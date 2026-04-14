module phase_detector (
    input clk,
    input rst,
    input A,
    input B,
    output reg [1:0] phase_out
);
    reg A_prev;
    reg B_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_prev <= 0;
            B_prev <= 0;
            phase_out <= 2'b00; // Default to in phase
        end else begin
            A_prev <= A;
            B_prev <= B;
            if (A_prev == B_prev) begin
                phase_out <= 2'b00; // In phase
            end else if (A_prev && !B_prev) begin
                phase_out <= 2'b01; // A leading
            end else if (!A_prev && B_prev) begin
                phase_out <= 2'b10; // A lagging
            end
        end
    end
endmodule