module siso_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [n-1:0] parallel_out
);
    parameter n = 5; // Width of the shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 0;
        end else begin
            parallel_out <= {parallel_out[n-2:0], serial_in}; // Shift left
        end
    end
endmodule