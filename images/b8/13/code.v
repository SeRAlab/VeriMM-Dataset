module binary_counter(
    input clk,
    input rst,
    output reg [3:0] count,
    output tc
);

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000;
    else
        count <= count + 1;
end

assign tc = (count == 4'b1111);

endmodule