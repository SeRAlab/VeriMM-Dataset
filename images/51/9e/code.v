module shift_register_8bit(
    input clk,          // Chip clock signal.
    input sin,          // Serial input signal.

    output sout         // Serial output signal.
);

reg [7:0] shift_reg; // Register to hold the shift register contents

// Shift register logic
always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], sin}; // Shift left and input new bit
end

assign sout = shift_reg[7]; // Most significant bit as serial output

endmodule