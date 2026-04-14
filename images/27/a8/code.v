module dwt_haar (
    input [7:0] data_in,
    output [7:0] approx_out,
    output [7:0] detail_out
);
    wire [3:0] low_pass;
    wire [3:0] high_pass;

    assign low_pass[0] = (data_in[0] + data_in[1]) >> 1;
    assign low_pass[1] = (data_in[2] + data_in[3]) >> 1;
    assign low_pass[2] = (data_in[4] + data_in[5]) >> 1;
    assign low_pass[3] = (data_in[6] + data_in[7]) >> 1;

    assign high_pass[0] = (data_in[0] - data_in[1]) >> 1;
    assign high_pass[1] = (data_in[2] - data_in[3]) >> 1;
    assign high_pass[2] = (data_in[4] - data_in[5]) >> 1;
    assign high_pass[3] = (data_in[6] - data_in[7]) >> 1;

    assign approx_out = {low_pass, low_pass};  // Repeat low_pass for the output
    assign detail_out = {high_pass, high_pass}; // Repeat high_pass for the output
endmodule