module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  A4,
    input  B1,
    input  sel,
    output reg X
);reg [3:0] sum;

    always @ (A1 or A2 or A3 or A4)
    begin
        sum <= A1 + A2 + A3 + A4;
    end

    always @ (sum or B1 or sel)
    begin
        if (sel)
            X <= B1;
        else
            X <= sum;
    end

endmodule