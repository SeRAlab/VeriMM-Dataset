module up_down_counter(
    input               clk,
    input               rst,
    input               up_down,
    
    output reg [11:0]   count
);

always@(posedge clk) begin
    if (rst)
        count <= 12'b000000000000;
    else if (up_down)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule