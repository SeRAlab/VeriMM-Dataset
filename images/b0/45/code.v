module binary_counter(
    input clk,
    input reset,
    output reg [3:0] Q
);

always @(posedge clk) begin
    if (reset)
        Q <= 4'b0000;
    else
        Q <= Q + 1;
end

endmodule