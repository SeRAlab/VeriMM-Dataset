module fixed_priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant
);
    always @(*) begin
        if (req0) begin
            grant = 1'b1; // Grant to req0
        end else if (req1) begin
            grant = 1'b1; // Grant to req1
        end else if (req2) begin
            grant = 1'b1; // Grant to req2
        end else if (req3) begin
            grant = 1'b1; // Grant to req3
        end else begin
            grant = 1'b0; // No grant
        end
    end
endmodule