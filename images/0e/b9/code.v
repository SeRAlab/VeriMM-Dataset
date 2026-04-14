module priority_arbiter(
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant1,
    output reg grant2,
    output reg grant3
);
    always @(*) begin
        // Default all grants to 0
        grant1 = 0;
        grant2 = 0;
        grant3 = 0;

        if (req1) begin
            grant1 = 1; // req1 has the highest priority
        end else if (req2) begin
            grant2 = 1; // req2 has the second priority
        end else if (req3) begin
            grant3 = 1; // req3 has the lowest priority
        end
    end
endmodule