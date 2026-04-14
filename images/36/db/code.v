module mux4to1 (
    input wire [3:0] data_in, // 4 input data lines
    input wire [1:0] sel,     // 2-bit select line
    output wire data_out       // output data line
);
    assign data_out = (sel == 2'b00) ? data_in[0] :
                      (sel == 2'b01) ? data_in[1] :
                      (sel == 2'b10) ? data_in[2] :
                                       data_in[3]; // sel == 2'b11
endmodule