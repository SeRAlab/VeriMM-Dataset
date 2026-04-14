module binary_counter(
    input clk,
    input rst,
    input en,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (rst)
        count <= 8'b0;
    else if (en)
        count <= count + 1;
end

endmodule