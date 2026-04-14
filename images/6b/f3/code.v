module top_module(
    input clk,
    input reset,
    output reg [4:0] count
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b10000;  // Synchronous reset to '10000'
        end else begin
            count <= {count[3:0], count[4]};  // Ring counter behavior
        end
    end

endmodule