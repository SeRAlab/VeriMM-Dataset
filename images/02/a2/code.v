module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant0,
    output reg grant1,
    output reg grant2,
    output reg grant3
);

always @(*) begin
    // Default all grants to 0
    grant0 = 0;
    grant1 = 0;
    grant2 = 0;
    grant3 = 0;

    // Grant the highest priority request
    if (req0) begin
        grant0 = 1;
    end else if (req1) begin
        grant1 = 1;
    end else if (req2) begin
        grant2 = 1;
    end else if (req3) begin
        grant3 = 1;
    end
end
endmodule