module up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire up,
    input wire down,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'd0;
    end else begin
        if (up && !down) begin
            count <= count + 4'd1;
        end else if (!up && down) begin
            count <= count - 4'd1;
        end
    end
end

endmodule