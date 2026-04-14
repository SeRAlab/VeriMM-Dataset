module top_module(
    input a, b, // Inputs for the half-adder
    input [2:0] sel, // Select input for the multiplexer
    input [3:0] data0, // 4-bit data inputs for the multiplexer
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [7:0] out // 8-bit output from the functional module
);// Define the half-adder
    wire sum = a ^ b;
    wire carry = a & b;

    // Define the 6-to-1 multiplexer
    reg [3:0] mux_out; // Change wire to reg
    always @*
    begin
        case (sel)
            3'b000: mux_out = data0;
            3'b001: mux_out = data1;
            3'b010: mux_out = data2;
            3'b011: mux_out = data3;
            3'b100: mux_out = data4;
            3'b101: mux_out = data5;
            default: mux_out = 4'b0001;
        endcase
    end

    // Define the functional module
    always @*
    begin
        out = {mux_out, sum, carry};
    end

endmodule