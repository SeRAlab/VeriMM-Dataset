module bluetooth_inverter (
    input [4:0] data_in,
    output [4:0] data_out
);
    assign data_out = ~data_in; // Inverting the input bits
endmodule