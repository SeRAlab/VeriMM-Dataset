module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire R0,
    input wire R1,
    input wire R2,
    output reg G0,
    output reg G1,
    output reg G2
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            G0 <= 0;
            G1 <= 0;
            G2 <= 0;
        end else begin
            G0 <= R0; // Grant R0 if requested
            G1 <= R1 & ~R0; // Grant R1 if R0 is not requesting
            G2 <= R2 & ~R0 & ~R1; // Grant R2 if neither R0 nor R1 is requesting
        end
    end
endmodule