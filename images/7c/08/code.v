module binary_counter(
    input clk,
    input reset,
    input en,
    output reg [2:0] Q
);

always @(posedge clk) begin
    if (reset)
        Q <= 3'b000;
    else if (en)
        Q <= Q + 1;
end

endmodule