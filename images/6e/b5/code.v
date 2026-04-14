module sipo_shift_register
(
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] parallel_out
);
    always @(posedge clk) begin
        if (reset) begin
            parallel_out <= 8'b0; // Clear register to 0
        end else begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift in serial data
        end
    end

endmodule