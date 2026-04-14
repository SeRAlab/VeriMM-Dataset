module down_counter(
    input               clk,
    input               rst,
    
    output reg [7:0]    count
);

always@(posedge clk or posedge rst) begin
    if (rst)
        count <= 8'b11111111;
    else
        count <= count - 1;
end

endmodule