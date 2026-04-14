module updown_counter_3bit(
    input  clk,
    input  enable,
    input  direction,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (enable) begin
        if (direction) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule