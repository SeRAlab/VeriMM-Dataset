module top_module(data0, data1, data2, data3, selectinput, out);input [15:0] data0, data1, data2, data3;
input [1:0] selectinput;
output [15:0] out;

wire [15:0] mux0, mux1;

// Implementing two 2-to-1 MUXes to select between data0 and data1, and data2 and data3
// The output of these MUXes are combined to form the final output
assign mux0 = (selectinput[0] == 0) ? data0 : data1;
assign mux1 = (selectinput[0] == 0) ? data2 : data3;

// Implementing the final 4-to-1 MUX using the outputs of the two 2-to-1 MUXes
assign out = (selectinput[1] == 0) ? mux0 : mux1;

endmodule