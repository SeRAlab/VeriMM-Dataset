module top_module(
    input [2:0] sel_mux, // Select input for the multiplexers
    input [3:0] data0, // Input data for the first multiplexer
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [3:0] data0_mux2, // Input data for the second multiplexer
    input [3:0] data1_mux2,
    input [3:0] data2_mux2,
    input [3:0] data3_mux2,
    input [3:0] data4_mux2,
    input [3:0] data5_mux2,
    output [3:0] out // Output of the adder
);// Multiplexer 1
wire [3:0] mux_out1;
assign mux_out1 = (sel_mux == 3'b000) ? data0 :
                  (sel_mux == 3'b001) ? data1 :
                  (sel_mux == 3'b010) ? data2 :
                  (sel_mux == 3'b011) ? data3 :
                  (sel_mux == 3'b100) ? data4 :
                  (sel_mux == 3'b101) ? data5 :
                  4'bzzzz;

// Multiplexer 2
wire [3:0] mux_out2;
assign mux_out2 = (sel_mux == 3'b000) ? data0_mux2 :
                  (sel_mux == 3'b001) ? data1_mux2 :
                  (sel_mux == 3'b010) ? data2_mux2 :
                  (sel_mux == 3'b011) ? data3_mux2 :
                  (sel_mux == 3'b100) ? data4_mux2 :
                  (sel_mux == 3'b101) ? data5_mux2 :
                  4'bzzzz;

// Adder
wire [3:0] add_out;
assign add_out = mux_out1 + mux_out2;

// Output
assign out = add_out;

endmodule