module top_module(
    input clk,
    input mode,
    input reset,
    output reg [11:0] count
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            count <= 12'b0;  // Synchronous reset to zero
        end else if (mode) begin
            count <= count + 1;  // Count up when mode is high
        end else begin
            count <= count - 1;  // Count down when mode is low
        end
    end

endmodule