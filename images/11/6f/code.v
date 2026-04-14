module SIPO (
    input wire clk,
    input wire serial_in,
    output reg [4:0] parallel_out
);
    always @(posedge clk) begin
        parallel_out <= {parallel_out[3:0], serial_in}; // Shift left and insert serial_in
    end
endmodule