module counter_4bit_updown(
    input clk,
    input reset,
    input up,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 4'b0;
    else if (up)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule