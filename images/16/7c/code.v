module sipo_shift_register (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [3:0] parallel_out
);
    reg [3:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 4'b0000;
            parallel_out <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], serial_in};  // Shift left and insert new bit
            if (shift_reg[3:0] != 4'b0000) begin
                parallel_out <= shift_reg;  // Output the current state of the shift register
            end
        end
    end
endmodule