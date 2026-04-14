module top_module(
    input [3:0] in1, // First 4-bit input for the adder/subtractor
    input [3:0] in2, // Second 4-bit input for the adder/subtractor
    input control, // Control signal for the adder/subtractor (0 for addition, 1 for subtraction)
    input [2:0] sel, // Select input for the multiplexer
    input [3:0] data0, // 4-bit data inputs for the multiplexer
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [7:0] out // 8-bit output from the functional module
);// 4-bit adder/subtractor using a 2-to-1 multiplexer
wire [3:0] add_out;
wire [3:0] sub_out;
assign add_out = in1 + in2;
assign sub_out = in1 - in2;

// Intermediate signals to avoid multiple drivers on 'out'
wire [3:0] add_sub_out;
assign add_sub_out = control ? sub_out : add_out;

// 6-to-1 multiplexer
wire [3:0] mux_out;
assign mux_out = (sel == 0) ? data0 :
                 (sel == 1) ? data1 :
                 (sel == 2) ? data2 :
                 (sel == 3) ? data3 :
                 (sel == 4) ? data4 :
                 (sel == 5) ? data5 :
                 4'b0000;

// Final 8-bit output
always @(*) begin
    out[3:0] = mux_out;          // Assign the output of the multiplexer to the lower 4 bits
    out[7:4] = add_sub_out;     // Assign the result of the adder/subtractor to the upper 4 bits
end

endmodule