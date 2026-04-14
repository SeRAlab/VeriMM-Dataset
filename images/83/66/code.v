module up_counter_8bit(
    input  clk,
    input  rst,
    input  enable,
    output reg [7:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 8'b00000000;
    end else if (enable) begin
        count <= count + 1;
    end
end

endmodule