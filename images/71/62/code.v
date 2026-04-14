module top_module(
    input clk,
    input reset,
    input en,
    output reg [1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b0;  // Reset counter
        else if (en)
            count <= count + 1;  // Increment counter on enable
    end

endmodule