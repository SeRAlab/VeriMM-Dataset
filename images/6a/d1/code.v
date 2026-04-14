module top_module(binary, decimal);input [3:0] binary;
    output [2:0] decimal;

    assign decimal = 8 * binary[3] + 4 * binary[2] + 2 * binary[1] + binary[0];

endmodule