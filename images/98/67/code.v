module top_module(
    input clk,
    input reset,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 3'b000;  // Reset counter
        else
            count <= count + 1;  // Increment counter
    end

endmodule