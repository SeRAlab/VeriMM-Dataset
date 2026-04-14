module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output reg [7:0] q,
    output reg q_out
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;  // Synchronous reset to zero
        end else if (load) begin
            q <= data_in;  // Load new data
        end else begin
            q <= {q[6:0], 1'b0};  // Shift left
        end
        q_out <= q[7];  // Output the last bit
    end

endmodule