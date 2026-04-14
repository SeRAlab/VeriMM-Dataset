module dac_controller (
    input [23:0] data_in,  // 24-bit input
    output [7:0] ctrl_out   // 8-bit output
);
    assign ctrl_out = data_in[23:16]; // Take the most significant 8 bits
endmodule