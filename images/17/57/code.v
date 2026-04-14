module sipo_shift_register (
    input clk,
    input reset,
    input serial_in,
    input load,
    output reg [4:0] parallel_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // Clear the shift register
            parallel_out <= 5'b00000; // Clear the output
        end else if (load) begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and add new bit
            parallel_out <= shift_reg; // Update parallel output with current shift register content
        end
    end
endmodule