module top_module(
    input clk,
    input reset,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 3'b000;  // Synchronous reset
        else
            count <= count + 1;  // Up counter
    end

endmodule