module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg gnt0,
    output reg gnt1,
    output reg gnt2,
    output reg gnt3
);
    always @(*) begin
        // Default grant outputs
        gnt0 = 0;
        gnt1 = 0;
        gnt2 = 0;
        gnt3 = 0;

        // Grant based on priority
        if (req0) begin
            gnt0 = 1;
        end else if (req1) begin
            gnt1 = 1;
        end else if (req2) begin
            gnt2 = 1;
        end else if (req3) begin
            gnt3 = 1;
        end
    end
endmodule