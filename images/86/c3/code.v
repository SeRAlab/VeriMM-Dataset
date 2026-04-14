module top_module(
    input [width - 1:0] i_data0,
    input [width - 1:0] i_data1,
    input [width - 1:0] i_data2,
    input [width - 1:0] i_data3,
    input i_select0,
    input i_select1,
    input i_select2,
    input i_select3,
    output reg [width - 1:0] o_data,
    output reg o_error
);parameter width = 1;

always @(*) begin
    // Select the input data signal based on the select signals
    case({i_select3, i_select2, i_select1, i_select0})
        4'b0001: o_data = i_data0;
        4'b0010: o_data = i_data1;
        4'b0100: o_data = i_data2;
        4'b1000: o_data = i_data3;
        default: o_data = 0;
    endcase

    // Set the error signal if more than one select signal is high
    if ({i_select3, i_select2, i_select1, i_select0} > 1)
        o_error = 1;
    else
        o_error = 0;
end

endmodule