module top_module(
    i_data,
    i_select,
    o_result);parameter width = 32;
    parameter channels = 5;

    input [width - 1:0] i_data;
    input [channels - 1:0] i_select;
    output o_result;

    assign o_result = i_data[i_select];
endmodule