module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire R0,
    input wire R1,
    input wire R2,
    output reg G0,
    output reg G1,
    output reg G2
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        G0 <= 0;
        G1 <= 0;
        G2 <= 0;
    end else begin
        // Default grants to zero
        G0 <= 0;
        G1 <= 0;
        G2 <= 0;

        // Grant based on priority
        if (R0) begin
            G0 <= 1;
        end else if (R1) begin
            G1 <= 1;
        end else if (R2) begin
            G2 <= 1;
        end
    end
end
endmodule