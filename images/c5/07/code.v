module simple_circuit(
    input [3:0] in_value,
    output [2:0] out_value
);

    assign out_value = (in_value <= 7) ? {3'b0, in_value} : 3'b111;

endmodule