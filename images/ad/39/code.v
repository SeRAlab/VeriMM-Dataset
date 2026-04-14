module top_module(
    Y,
    A,
    B,
    C,
    D,
    EN
);output Y;
    input A;
    input B;
    input C;
    input D;
    input EN;

    wire [1:0] sel;
    assign sel = {C, B};

    wire [3:0] mux_input;
    assign mux_input = {A, B, C, D};

    wire [3:0] mux_output;
    assign mux_output = mux_input & (2'b11 << sel);

    assign Y = EN ? mux_output : 1'b0;

endmodule