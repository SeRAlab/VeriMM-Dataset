module siso_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] parallel_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        parallel_out <= 5'b00000; // Reset the shift register
    end else begin
        parallel_out <= {parallel_out[3:0], serial_in}; // Shift left and input new bit
    end
end

endmodule