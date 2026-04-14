module SIPO_Shift_Register (
    input wire clk,              // Clock input
    input wire rst,              // Reset input
    input wire serial_in,        // Serial data input
    input wire load,             // Load control signal
    output reg [7:0] parallel_out // 8-bit parallel output
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 8'b00000000; // Reset output
        end else if (load) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift left and load new bit
        end
    end
endmodule