module top_module(
    input clk,
    input [15:0] in,
    output [7:0] out
);// Barrel shifter to split input into lower and upper bytes
    wire [7:0] lower_byte = in[7:0];
    wire [7:0] upper_byte = in[15:8];

    // Shift register with length of 3 using master-slave flip-flops
    reg [2:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], lower_byte[0]}; // Using the LSB of lower_byte for shift
    end
    wire q = shift_reg[2];

    // Functional module to XOR the outputs of the barrel shifter and shift register
    wire [7:0] xor_output = lower_byte ^ upper_byte ^ {7'b0, q}; // Adjusting q to match bit width

    // Output the 8-bit result of the XOR operation
    assign out = xor_output;

endmodule