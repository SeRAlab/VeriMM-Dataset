module top_module(
    input clk,
    input reset,
    input en,
    output reg [3:0] count
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;  // Synchronous reset to all zeros
        end else if (en) begin
            count <= count + 1;  // Increment the counter when enable is high
        end
    end

endmodule