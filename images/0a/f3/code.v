module SIPO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [4:0] parallel_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 5'b00000;
        end else begin
            parallel_out <= {parallel_out[3:0], serial_in}; // Shift left and input new bit
        end
    end
endmodule