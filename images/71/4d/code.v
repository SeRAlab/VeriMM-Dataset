module down_counter_8bit(
    input clk,
    input rst_n,
    input enable,
    output reg [7:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 8'hFF;
    end else if (enable) begin
        if (count == 8'h00) begin
            count <= 8'hFF;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule