module up_down_counter_3bit(
    input clk,
    input rst,
    input up,
    input down,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b000;
    end else if (up && !down) begin
        count <= count + 1;
    end else if (!up && down) begin
        count <= count - 1;
    end
end

endmodule