module up_down_counter_3bit(
    input wire clk,
    input wire rst,
    input wire up,
    output reg [2:0] count
    );

always @(posedge clk) begin
    if (rst)
        count <= 3'b000;
    else if (up)
        count <= count + 1'b1;
    else
        count <= count - 1'b1;
end

endmodule