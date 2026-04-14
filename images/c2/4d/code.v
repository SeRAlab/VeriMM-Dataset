module majority_gate (
    // input ports
    input A,
    input B,
    input C,
    input D,
    // output ports
    output X
);

    wire AB = A & B;
    wire AC = A & C;
    wire AD = A & D;
    wire BC = B & C;
    wire BD = B & D;
    wire CD = C & D;

    wire majority1 = AB | AC | AD | BC | BD | CD;
    wire majority0 = ~AB & ~AC & ~AD & ~BC & ~BD & ~CD;

    assign X = (majority1 & ~majority0);

endmodule