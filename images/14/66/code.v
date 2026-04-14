module siso_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] serial_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 5'b00000; // Reset the shift register
        end else begin
            serial_out <= {serial_out[3:0], serial_in}; // Shift left and insert new bit
        end
    end
endmodule