module binary_counter (
    input clk,
    input reset,
    output reg[3:0] count,
    output reg max_count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
        max_count <= 1'b0;
    end else begin
        if (count == 4'b1111) begin
            count <= 4'b0000;
            max_count <= 1'b1;
        end else begin
            count <= count + 1;
            max_count <= 1'b0;
        end
    end
end

endmodule