module dual_edge_dff
    (
        input clk,
        input d,
        input rst,
        output reg q
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule