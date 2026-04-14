module top_module(
    input clk,
    input reset_n,
    input load,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the counter to 8'b00000000
            q <= 8'b00000000;
        end else if (load) begin
            // Load the specified value into the counter
            q <= data;
        end else begin
            // Increment the counter
            q <= q + 1;
        end
    end

endmodule