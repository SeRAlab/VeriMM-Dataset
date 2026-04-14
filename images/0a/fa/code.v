module mux4to1 (
    input wire [3:0] data_in,  // 4-bit input data
    input wire [1:0] sel,      // 2-bit select signal
    output wire out            // output of the multiplexer
);
    assign out = (sel == 2'b00) ? data_in[0] :
                 (sel == 2'b01) ? data_in[1] :
                 (sel == 2'b10) ? data_in[2] :
                 data_in[3]; // default case
endmodule