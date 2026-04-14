module up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire count_up,
    input wire count_down,
    output reg [7:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 8'b0;
    end else if (count_up) begin
        count <= count + 1;
    end else if (count_down) begin
        count <= count - 1;
    end
end

endmodule