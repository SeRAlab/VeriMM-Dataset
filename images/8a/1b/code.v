module top_module( 
    input wire clk,
    input wire [2:0] sel, 
    input wire [3:0] data0,
    input wire [3:0] data1,
    input wire [3:0] data2,
    input wire [3:0] data3,
    input wire [3:0] data4,
    input wire [3:0] data5,
    output wire [3:0] out_mux,
    output wire [2:0] out_3bit,
    output wire o2,
    output wire o1,
    output wire o0,
    output wire [6:0] final_out
);// 6-to-1 Multiplexer
wire [3:0] mux_out;
assign mux_out = (sel == 0) ? data0 :
                 (sel == 1) ? data1 :
                 (sel == 2) ? data2 :
                 (sel == 3) ? data3 :
                 (sel == 4) ? data4 :
                 (sel == 5) ? data5 : 4'b0;
assign out_mux = mux_out;

// 3-bit Input Module
assign out_3bit = sel;
assign o2 = sel[2];
assign o1 = sel[1];
assign o0 = sel[0];

// Functional Module
wire [6:0] add_out;
wire carry_out;
assign {carry_out, add_out} = {1'b0, mux_out} + {1'b0, sel};
assign final_out = {carry_out, add_out};

endmodule