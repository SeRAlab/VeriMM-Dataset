module up_down_counter
(
    input clk,
    input areset,
    input up,
    input down,
    output reg [2:0] count
);always @(posedge clk or posedge areset)
    if (areset) begin
        count <= 3'b000;
    end else if (up) begin
        count <= count + 1;
    end else if (down) begin
        count <= count - 1;
    end
endmodule