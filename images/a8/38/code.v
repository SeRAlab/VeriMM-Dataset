module top_module(
    out_signal,
    in_signal1,
    in_signal2,
    in_signal3,
    in_signal4,
    in_signal5,
    in_signal6
);output out_signal;
    input in_signal1;
    input in_signal2;
    input in_signal3;
    input in_signal4;
    input in_signal5;
    input in_signal6;

    assign out_signal = (in_signal1 & in_signal2 & in_signal3 & in_signal4 & in_signal5 & in_signal6);

endmodule