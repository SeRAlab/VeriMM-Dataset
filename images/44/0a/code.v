module shift_register_with_load(
    input clk,
    input reset_n,
    input load,
    input [11:0] data_in,
    output reg [11:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the shift register to 12'b000000000000
            q <= 12'b000000000000;
        end else if (load) begin
            // Parallel load operation: Load input data when load is high
            q <= data_in;
        end else begin
            // Shift right operation: Shift right by one bit
            q <= {q[0], q[11:1]};
        end
    end

endmodule