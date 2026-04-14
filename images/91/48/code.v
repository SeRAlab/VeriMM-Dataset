module up_down_counter_3bit (
    input clk,
    input reset,
    input up_down,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 3'b000;
    end else begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule