module PIPO_Shift_Register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg [7:0] parallel_out
);
    always @(posedge clk) begin
        if (enable) begin
            if (load) begin
                parallel_out <= parallel_in; // Load data
            end else if (shift) begin
                parallel_out <= {1'b0, parallel_out[7:1]}; // Shift right
            end
        end
    end
endmodule