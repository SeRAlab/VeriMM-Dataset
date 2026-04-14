module counter_3bit(
    input               clk  ,
    input               en   ,
    output reg [2:0]    count
);

always @(posedge clk) begin
    if (en) begin
        count <= count + 1;
    end
end

endmodule