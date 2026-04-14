module counter_4bit(
    input clk,
    input reset,
    input en,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else if (en)
        count <= (count == 4'b1111) ? 4'b0000 : count + 1;
end

endmodule