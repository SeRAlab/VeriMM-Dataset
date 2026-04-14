module up_down_counter(
    input               clk,
    input               rst,
    input               up_down,
    
    output reg [2:0]    count
);

always@(posedge clk or posedge rst) begin
    if (rst)
        count <= 3'b000;
    else begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule