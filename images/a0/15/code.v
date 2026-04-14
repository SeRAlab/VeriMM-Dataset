module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    // Next state logic for Gray code
    function [2:0] next_gray;
        input [2:0] current;
        begin
            next_gray = current ^ (current >> 1);
        end
    endfunction

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;
        end else begin
            q <= next_gray(q + 1); // Increment and convert to Gray code
        end
    end
endmodule