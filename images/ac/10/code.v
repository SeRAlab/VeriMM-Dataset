module top_module( 
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);wire [3:0] mux_out;
wire [3:0] and_out;

// 6-to-1 Multiplexer
assign mux_out = (sel == 3'b000) ? data0 :
                 (sel == 3'b001) ? data1 :
                 (sel == 3'b010) ? data2 :
                 (sel == 3'b011) ? data3 :
                 (sel == 3'b100) ? data4 :
                 (sel == 3'b101) ? data5 :
                 4'b0000;

// Logical AND with 1010
assign and_out = mux_out & 4'b1010;

// Output
assign out = and_out;

endmodule