module top_module(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);wire [3:0] mux0_out, mux1_out, mux2_out, mux3_out, mux4_out, mux5_out;
wire [3:0] and_out;

// 2-to-1 MUX
assign mux0_out = (sel[0] == 0) ? data0 : data1;
assign mux1_out = (sel[0] == 0) ? data2 : data3;
assign mux2_out = (sel[0] == 0) ? data4 : data5;

// 4-to-1 MUX
assign mux3_out = (sel[1] == 0) ? mux0_out : mux1_out;
assign mux4_out = (sel[1] == 0) ? mux2_out : 4'b0000;

// AND gate
assign and_out = (sel > 5) ? (mux4_out & sel) : 4'b0000;

// Final 2-to-1 MUX
assign out = (sel[2] == 0) ? mux3_out : and_out;

endmodule