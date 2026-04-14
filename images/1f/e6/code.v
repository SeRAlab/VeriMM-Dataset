module PIPO_Shift_Register (
    input clk,
    input reset,
    input load,
    input shift,
    input [7:0] parallel_in,
    output reg [7:0] parallel_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        parallel_out <= 8'b0;
    end else if (load) begin
        parallel_out <= parallel_in;
    end else if (shift) begin
        parallel_out <= {parallel_out[6:0], 1'b0}; // Shift left and fill with 0
    end
end

endmodule