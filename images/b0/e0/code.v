module top_module(
    input clk,
    input rst,
    input en,
    input d,
    output reg q
);reg q_d;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            q_d <= 1'b0;
        end else if (en) begin
            q_d <= d;
        end
    end

    always @ (posedge clk) begin
        q <= q_d;
    end

endmodule