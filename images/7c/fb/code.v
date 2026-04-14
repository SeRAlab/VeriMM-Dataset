module top_module(
    input clk, // clock input
    input reset, // synchronous reset input
    output reg [3:0] count // 4-bit output
);always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // reset the counter to 0
    end else begin
        count <= count + 1; // increment the counter
    end
end

endmodule