module sync_counter(
    input clk,
    input reset,
    input load,
    input [2:0] data,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            q <= 3'b000;
        end else if (load) begin
            // Load the counter with data
            q <= data;
        end else begin
            // Increment the counter
            q <= q + 1;
        end
    end

endmodule