module binary_down_counter_3bit(
    input clk,
    input rst_n,
    output reg [2:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b111;
    end else begin
        count <= count - 1;
    end
end

endmodule