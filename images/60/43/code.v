module top_module(
    input clk,
    input enable,
    input reset,
    output reg [3:0] q
);reg [3:0] q_reg; // register to hold current value of counter

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'b0000; // reset counter to 0000
    end else if (enable) begin
        q_reg <= {q_reg[2:0], q_reg[3]}; // shift counter value left by 1 bit
        q <= q_reg; // output shifted value
    end
end

endmodule