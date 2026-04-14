module top_module(
    input clk,
    input sync_set,
    input async_set,
    input [31:0] d,
    output reg [31:0] q
);

    // Always block triggered on the rising edge of the clock or on async_set
    always @(posedge clk or posedge async_set) begin
        if (async_set) begin
            q <= 32'b11111111111111111111111111111111;  // Asynchronous set to all ones
        end else if (sync_set) begin
            q <= 32'b11111111111111111111111111111111;  // Synchronous set to all ones
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule