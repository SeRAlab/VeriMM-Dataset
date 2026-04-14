module fixed_priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    output reg grant
);
    always @(*) begin
        grant = 0; // Default no grant
        if (req0) begin
            grant = 1; // Grant to req0
        end else if (req1) begin
            grant = 2; // Grant to req1
        end else if (req2) begin
            grant = 3; // Grant to req2
        end
    end
endmodule