module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,
    input rst,
    output reg [15:0] out
);integer i, j;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out <= 16'b0;
        end
        else begin
            out <= 16'b0;
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    if ((i+j) < 16) begin
                        out[i+j] <= out[i+j] + (a[i] & b[j]);
                    end
                end
            end
        end
    end

endmodule