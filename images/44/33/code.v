module piso_shift_register (
    input clk,
    input reset,
    input load,
    input [7:0] parallel_in,
    output serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;  // Reset the register to 0
        end else if (load) begin
            shift_reg <= parallel_in;  // Load parallel data
        end else begin
            shift_reg <= {shift_reg[6:0], 1'b0};  // Shift left with serial out
        end
    end

    assign serial_out = shift_reg[7];

endmodule