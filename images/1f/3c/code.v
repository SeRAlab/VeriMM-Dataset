module SIPO_Shift_Register #(parameter N = 5) (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [N-1:0] parallel_out
);

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 0;
        end else begin
            parallel_out <= {parallel_out[N-2:0], serial_in}; // Shift left and insert new bit
        end
    end
endmodule