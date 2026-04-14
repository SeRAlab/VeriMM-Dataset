module up_down_counter(
    input clk,
    input up,
    input down,
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (up && !down) begin
            count <= count + 1;
        end else if (!up && down) begin
            count <= count - 1;
        end
    end
endmodule