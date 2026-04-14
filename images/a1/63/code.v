module top_module(
    input i_a,
    input i_b,
    input i_cin,
    output o_result,
    output o_cout);assign o_result = i_a ^ i_b ^ i_cin;
    assign o_cout = (i_a & i_b) | (i_a & i_cin) | (i_b & i_cin);
endmodule