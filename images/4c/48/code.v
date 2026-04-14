module sync_up_counter_4bit(clk, reset, Q);
input clk, reset;
output reg [3:0] Q;

always @(posedge clk) begin
    if (reset)
        Q <= 4'b0000;
    else
        Q <= Q + 1;
end

endmodule