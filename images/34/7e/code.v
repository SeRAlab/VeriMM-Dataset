module siso_shift_register (
    input clk,
    input rst,
    input serial_in,
    output reg [4:0] serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000;
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and input serial_in
        end
    end

    always @(posedge clk) begin
        serial_out <= shift_reg; // Output the current state of the shift register
    end
endmodule