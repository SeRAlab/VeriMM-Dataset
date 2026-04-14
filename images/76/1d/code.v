module shift_register
(
    input clk,
    input areset,
    input shift,
    input load,
    input [15:0] data_in,
    output reg [15:0] q
);
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 16'b0; // Reset register to 0
        end else if (load) begin
            q <= data_in; // Load parallel input data
        end else if (shift) begin
            q <= q << 1; // Shift left
        end
    end

endmodule