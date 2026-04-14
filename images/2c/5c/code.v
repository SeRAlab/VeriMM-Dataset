module fixed_priority_arbiter (
    input wire request0,
    input wire request1,
    input wire request2,
    input wire request3,
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

        // Grant based on priority
        if (request0) begin
            grant0 = 1;
        end else if (request1) begin
            grant1 = 1;
        end else if (request2) begin
            grant2 = 1;
        end else if (request3) begin
            grant3 = 1;
        end
    end
endmodule