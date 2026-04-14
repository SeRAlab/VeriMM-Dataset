module top_module(
    input [7:0] bus_in,
    output [7:0] bus_out,
    output reg [2:1] selected_bits_1_2,
    output reg [3:1] selected_bits_3_5
);assign bus_out = bus_in & 8'b00010001; // Bitwise AND with constant 17

    always @(*) begin
        selected_bits_1_2 = bus_in[2:1]; // Select bits 1 and 2
        selected_bits_3_5 = bus_in[5:3]; // Select bits 3 to 5
    end

endmodule