module shift_register (
    input wire clk,
    input wire shift,
    input wire [15:0] parallel_in,
    input wire load,
    output reg [15:0] parallel_out
);

always @(posedge clk) begin
    if (load) begin
        parallel_out <= parallel_in; // Load data on load signal
    end else if (shift) begin
        parallel_out <= {parallel_out[14:0], 1'b0}; // Shift left with 0 fill
    end
end

endmodule