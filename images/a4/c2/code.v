module down_counter(
    input clk,
    input rst_n,
    input enable,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (!rst_n)
        count <= 4'd15;
    else if (enable)
        count <= (count == 4'd0) ? 4'd15 : count - 4'd1;
end

endmodule