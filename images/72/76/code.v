module binary_counter(
    input clk,
    input rst_n,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 0;
    else
        count <= count + 1;
end

endmodule