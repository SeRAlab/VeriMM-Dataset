module shift_reg_8bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input load,         // Load signal to load the shift register with a specific value.
    input si,           // Serial input signal.
    input [7:0] pi,     // 8-bit parallel input.

    output [7:0] po,    // 8-bit parallel output.
    output so           // Serial output signal.
);

reg [7:0] reg_r; // Shift register.

//------------------------------------------------
// Shift register operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_r <= 8'b0;
    end
    else if (load) begin
        reg_r <= pi; // Load the shift register with the parallel input value.
    end
    else begin
        reg_r <= {reg_r[6:0], si}; // Shift left and shift in the serial input signal.
    end
end

assign po = reg_r;
assign so = reg_r[7]; // Serial output is the most significant bit.

endmodule