module counter_3bit_updown(
    input clk,
    input reset,
    input dir,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 3'b000;
    else if (dir)
        count <= (count == 3'b111) ? 3'b000 : count + 1;
    else
        count <= (count == 3'b000) ? 3'b111 : count - 1;
end

endmodule