module second_most_significant_bit (
    input [3:0] data,
    output reg q
);

    assign q = data[2];

endmodule