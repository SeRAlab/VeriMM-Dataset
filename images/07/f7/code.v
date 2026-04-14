module DVFS_Controller (
    input [3:0] load,        // 4-bit input for load
    input clk,               // clock signal
    output reg [1:0] freq    // 2-bit output for frequency levels
);

always @(posedge clk) begin
    if (load <= 4'd3)
        freq <= 2'b00; // Low frequency
    else if (load <= 4'd6)
        freq <= 2'b01; // Medium frequency
    else
        freq <= 2'b10; // High frequency
end

endmodule