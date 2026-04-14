module shift_register(
    input clk,
    input reset,
    input load,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to zero
            q <= 4'b0000;
        end else if (load) begin
            // Parallel load: Load data into the shift register
            q <= data;
        end else begin
            // Shift operation: Shift left by one position
            q <= {q[2:0], 1'b0};
        end
    end

endmodule