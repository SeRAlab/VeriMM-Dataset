module up_down_counter(
    input clk,
    input rst,
    input up,
    input down,
    output reg [3:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 4'd0;
    end else if (up && !down) begin
        q <= q + 1;
    end else if (down && !up) begin
        q <= q - 1;
    end
end

endmodule