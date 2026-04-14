module top_module(
    input [4:0] data,
    output [5:0] parity);

    assign parity = {data, ^data};

endmodule