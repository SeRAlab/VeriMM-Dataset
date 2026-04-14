module top_module(
    input clk,
    input reset,
    input load,
    input [5:0] data,
    output reg [5:0] q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 6'd0;  // Asynchronous reset to 0
        end else if (load) begin
            q <= data;  // Synchronous load the input data
        end else begin
            q <= q + 6'd1;  // Increment the counter
        end
    end

endmodule