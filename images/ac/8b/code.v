module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input C1,
    input CTRL,
    output Y
);wire cond1, cond2, cond3, cond4;

    assign cond1 = (CTRL == 0) && A1 && A2 && A3;
    assign cond2 = (CTRL == 1) && A1 && A2 && A3 && B1 && !C1;
    assign cond3 = (CTRL == 1) && A1 && A2 && A3 && B1 && C1;
    assign cond4 = (CTRL == 1) && A1 && A2 && A3 && !B1 && C1;

    assign Y = cond1 || cond2 || cond3 || cond4;

endmodule