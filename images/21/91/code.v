module shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] shift_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_out <= 8'b10101010; // Predefined 8-bit value
        end else begin
            shift_out <= {serial_in, shift_out[7:1]}; // Shift right
        end
    end
endmodule