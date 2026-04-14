module down_counter(
    input               clk,
    input               rst,
    
    output reg [15:0]   count
);

always@(posedge clk or posedge rst) begin
    if (rst)
        count <= 16'b0000000000000000;
    else
        count <= count - 1;
end

endmodule