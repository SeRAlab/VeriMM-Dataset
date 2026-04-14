module top_module(
    input [7:0] input_num,
    input control_signal,
    output [7:0] shifted_num
);assign shifted_num = (control_signal == 1) ? (input_num << 1) : (input_num >> 1);

endmodule