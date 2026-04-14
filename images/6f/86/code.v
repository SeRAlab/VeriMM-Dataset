module top_module(
    input clk,
    input reset,
    output reg [3:0] ring_counter);always @(posedge clk) begin
    if (reset)
        ring_counter <= 4'b0001;
    else
        ring_counter <= {ring_counter[2:0], ring_counter[3]};
end
endmodule