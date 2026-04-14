module counter_2bit
(
    input clk,
    input rst,
    input enable,
    output reg [1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 2'b00;
    else if (enable)
        count <= count + 1;
end

endmodule