module up_down_counter(
    input clk,
    input rst,
    input up,
    input down,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'd0;
    end else if (up && !down) begin
        count <= count + 1;
    end else if (down && !up) begin
        count <= count - 1;
    end
end

endmodule