module top_module(
    input clk,
    input reset,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 4'b1111;  // Reset counter to maximum
        else
            count <= count - 1;  // Decrement counter
    end

endmodule