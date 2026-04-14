module top_module(
    input clk,
    input reset,
    output reg [9:0] count
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            count <= 10'b0;  // Synchronous reset to zero
        end else begin
            count <= {count[8:0], ~count[9]};  // Johnson counter behavior
        end
    end

endmodule