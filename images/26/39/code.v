module SIPO (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] parallel_out
);
    reg [4:0] shift_reg;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            parallel_out <= 5'b0;
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift in the new bit
            if (shift_reg[4] == 1'b1) // Check if the last bit is valid for output
                parallel_out <= shift_reg; // Output the shifted register
        end
    end
endmodule