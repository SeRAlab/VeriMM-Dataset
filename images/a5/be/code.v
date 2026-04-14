module down_counter_16bit(
    input  clk,
    input  rst,
    input  enable,
    input  [15:0] rst_val,
    output reg [15:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= rst_val;
    end else if (enable) begin
        count <= count - 1;
    end
end

endmodule