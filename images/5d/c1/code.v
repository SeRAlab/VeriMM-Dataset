module top_module(
    input logic [31:0] in_signal,
    output logic [15:0] out_signal1,
    output logic [15:0] out_signal2
);assign out_signal1 = in_signal[15:0];
    assign out_signal2 = {1'b0, in_signal[31:16]};

endmodule