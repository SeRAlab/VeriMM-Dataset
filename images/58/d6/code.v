module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg X
);always @ (A or B or C or D)
begin
    if ((~A & B & ~C & ~D) == 1)
        X = 1;
    else if ((~A & ~B & C & D) == 1)
        X = 1;
    else if ((A & D & ~B & ~C) == 1)
        X = 1;
    else if ((A & B & C & ~D) == 1)
        X = 1;
    else if ((~A & ~B & C & ~D) == 1)
        X = 1;
    else if ((D & ~B & C) == 1)
        X = 1;
    else if ((~A & B & C & D) == 1)
        X = 1;
    else if ((A & ~B & C & ~D) == 1)
        X = 1;
    else if ((~A & ~B & C & ~D) == 1)
        X = 1;
    else if ((A & B & C & D) == 1)
        X = 1;
    else
        X = 0;
end

endmodule