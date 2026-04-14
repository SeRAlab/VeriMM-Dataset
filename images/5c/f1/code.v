module top_module(
    input i_clk,
    input i_reset,
    input i_count_up,
    input i_count,
    output reg [3:0] o_count
);always @(posedge i_clk) begin
    if (i_reset) begin
        o_count <= 4'b0000;
    end else if (i_count) begin
        if (i_count_up) begin
            if (o_count == 4'b1111) begin
                o_count <= 4'b0000;
            end else begin
                o_count <= o_count + 1;
            end
        end else begin
            if (o_count == 4'b0000) begin
                o_count <= 4'b1111;
            end else begin
                o_count <= o_count - 1;
            end
        end
    end
end

endmodule