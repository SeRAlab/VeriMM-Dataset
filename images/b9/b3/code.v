module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire TG1, TG2, TG3, TG4;

assign TG1 = S1 & S0;
assign TG2 = S1 & ~S0;
assign TG3 = ~S1 & S0;
assign TG4 = ~S1 & ~S0;

assign Y = (A & TG4) | (B & TG3) | (C & TG2) | (D & TG1);

endmodule