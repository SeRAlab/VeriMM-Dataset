module siso_shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [3:0] parallel_out,
    output reg serial_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 4'b0000;
            serial_out <= 1'b0;
        end else begin
            serial_out <= parallel_out[0]; // Output the oldest bit
            parallel_out <= {serial_in, parallel_out[3:1]}; // Shift left and insert new bit
        end
    end
endmodule