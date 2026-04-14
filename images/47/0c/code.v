module top_module(
    input [2:0] sel, // Select input for the 6-to-1 mux
    input [3:0] data0, // Input 0 for the 6-to-1 mux
    input [3:0] data1, // Input 1 for the 6-to-1 mux
    input [3:0] data2, // Input 2 for the 6-to-1 mux
    input [3:0] data3, // Input 3 for the 6-to-1 mux
    input [3:0] data4, // Input 4 for the 6-to-1 mux
    input [3:0] data5, // Input 5 for the 6-to-1 mux
    input [7:0] a, b, c, d, // Inputs for the 4-way minimum circuit
    output [7:0] out // Output of the functional module
);// 6-to-1 multiplexer
wire [3:0] mux_out;
assign mux_out = (sel == 3'b000) ? data0 :
                 (sel == 3'b001) ? data1 :
                 (sel == 3'b010) ? data2 :
                 (sel == 3'b011) ? data3 :
                 (sel == 3'b100) ? data4 :
                 (sel == 3'b101) ? data5 :
                 4'b0000;

// 4-way minimum circuit
wire [7:0] min_out;
assign min_out = (a < b) ? a : b;
assign min_out = (c < min_out) ? c : min_out;
assign min_out = (d < min_out) ? d : min_out;

// XOR output
assign out = mux_out ^ min_out;

endmodule