module top_module(
    input clk,                  // Clock signal
    input [7:0] in,             // 8-bit input vector
    input select,               // Select input to choose between module outputs
    output [7:0] out            // 8-bit final output
);reg [7:0] reverse_out;      // Output of shift register that reverses bit order
    reg [7:0] shift_out;        // Output of 3-bit shift register
    reg [2:0] shift_reg;        // 3-bit shift register implemented using D flip-flops
    wire [7:0] and_out;         // Output of bitwise AND operation between shift registers

    // Shift register that reverses bit order
    always @ (posedge clk) begin
        reverse_out <= {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
    end

    // 3-bit shift register implemented using D flip-flops and multiplexer
    always @ (posedge clk) begin
        if (select) begin
            shift_out <= reverse_out;
        end else begin
            shift_reg <= {shift_reg[1:0], in[7]};
            shift_out <= {shift_reg, 5'b00000}; // Corrected concatenation
        end
    end

    // Bitwise AND operation between shift registers
    assign and_out = reverse_out & shift_out;

    // Output selection based on select input
    assign out = select ? reverse_out : and_out;

endmodule