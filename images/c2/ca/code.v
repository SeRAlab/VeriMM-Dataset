module inv_module (
    input [3:0] data_in,
    input enable,
    output [3:0] data_out
);

    wire [3:0] inverted_data;

    assign inverted_data = ~data_in;

    assign data_out = enable ? inverted_data : data_in;

endmodule