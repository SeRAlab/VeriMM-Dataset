module hazard_detection (
    input A,
    input B,
    input clk,
    output reg Z
);
    reg Z_prev;

    always @(posedge clk) begin
        if (A == 1 && B == 1) begin
            Z <= 1;
            Z_prev <= 1;
        end else if (A == 0 && B == 0) begin
            Z <= 0;
            Z_prev <= 0;
        end else if (A == 1 && B == 0) begin
            Z <= 0;
            Z_prev <= 0;
        end else if (A == 0 && B == 1) begin
            // Hazard detected, hold previous value
            Z <= Z_prev;
        end
    end
endmodule