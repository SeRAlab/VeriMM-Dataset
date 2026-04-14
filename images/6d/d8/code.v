module top_module(
    input clk,
    input reset,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'd255;  // Asynchronous reset to 255
        end else begin
            q <= q - 8'd1;  // Decrement the counter
        end
    end

endmodule