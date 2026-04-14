module up_counter_12bit(
    input clk,
    input rst_n,
    input enable,
    output reg [11:0] count,
    output reg tc
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 12'b0;
        tc <= 0;
    end else if (enable) begin
        if (count == 12'hFFF) begin
            count <= 12'b0;
            tc <= 1;
        end else begin
            count <= count + 1;
            tc <= 0;
        end
    end
end

endmodule