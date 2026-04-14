module SISO_Register (
    input clk,
    input reset,
    input serial_in,
    output reg [4:0] serial_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        serial_out <= 5'b00000;
    end else begin
        serial_out <= {serial_out[3:0], serial_in}; // Shift in the serial data
    end
end

endmodule