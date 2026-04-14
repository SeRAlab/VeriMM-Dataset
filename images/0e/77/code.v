module SIPO (
    input wire clk,
    input wire enable,
    input wire serial_in,
    output reg [4:0] parallel_out
);
    always @(posedge clk) begin
        if (enable) begin
            parallel_out <= {parallel_out[3:0], serial_in}; // Shift left and insert new bit
        end
    end
endmodule