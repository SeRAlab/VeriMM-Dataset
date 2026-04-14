module phase_detector (
    input wire clk,
    input wire A,
    input wire B,
    output reg [1:0] phase_out
);

    reg A_prev, B_prev;

    always @(posedge clk) begin
        A_prev <= A;
        B_prev <= B;
        if (A_prev == B_prev) begin
            phase_out <= 2'b10; // In sync
        end else if (A_prev && !B_prev) begin
            phase_out <= 2'b01; // A leads B
        end else begin
            phase_out <= 2'b00; // A lags B
        end
    end
endmodule