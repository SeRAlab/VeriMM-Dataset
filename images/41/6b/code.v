module up_counter_4bit(
    input clk,
    input rst_n,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'b0000;
    else
        count <= count + 1;
end

endmodule