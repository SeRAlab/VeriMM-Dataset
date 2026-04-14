module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req, // request signals
    output reg [3:0] grant // grant signals
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000; // No grants on reset
        end else begin
            grant <= 4'b0000; // Default no grant
            if (req[0]) grant[0] <= 1'b1; // Grant to R0 if requested
            else if (req[1]) grant[1] <= 1'b1; // Grant to R1 if R0 not requested
            else if (req[2]) grant[2] <= 1'b1; // Grant to R2 if R0 and R1 not requested
            else if (req[3]) grant[3] <= 1'b1; // Grant to R3 if R0, R1, and R2 not requested
        end
    end
endmodule