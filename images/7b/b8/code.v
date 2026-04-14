module up_down_counter_4bit
(
    input clk,
    input up_down,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule