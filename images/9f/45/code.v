module top_module(
    input [2:0] sel, // input for multiplexer select
    input [3:0] data0, // data inputs for multiplexer
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [3:0] in, // input for priority encoder
    output [7:0] q  // 8-bit output from the functional module
);// 6-to-1 multiplexer
    wire [3:0] mux_out;
    assign mux_out = (sel == 0) ? data0 :
                     (sel == 1) ? data1 :
                     (sel == 2) ? data2 :
                     (sel == 3) ? data3 :
                     (sel == 4) ? data4 :
                     (sel == 5) ? data5 : 4'b0000;

    // 4-bit priority encoder
    wire [1:0] enc_out;
    assign enc_out = (in[3]) ? 2'b11 :
                     (in[2]) ? 2'b10 :
                     (in[1]) ? 2'b01 :
                     (in[0]) ? 2'b00 : 2'b00;

    // Functional module
    assign q = {enc_out, 4'b0000} + mux_out;

endmodule