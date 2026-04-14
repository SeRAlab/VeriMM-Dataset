module top_module(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q1
);always @(posedge clk or posedge reset) begin
        if (reset)
            q1 <= 8'b0;
        else
            q1 <= d; // Example functionality; adjust as needed
    end
endmodule