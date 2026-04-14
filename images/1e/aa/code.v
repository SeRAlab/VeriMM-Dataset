module priority_arbiter(
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
        gnt0 = 0;
        gnt1 = 0;
        gnt2 = 0;
        gnt3 = 0;

        if (req0)
            gnt0 = 1;
        else if (req1)
            gnt1 = 1;
        else if (req2)
            gnt2 = 1;
        else if (req3)
            gnt3 = 1;
    end
endmodule