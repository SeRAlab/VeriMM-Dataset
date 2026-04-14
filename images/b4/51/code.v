module top_module(
    input clk,
    input rst,
    input ena,
    input ld,
    input [3:0] data,
    output reg [3:0] q
);always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0;
        end
        else if (ena) begin
            if (ld) begin
                q <= data;
            end
            else begin
                if (q == 4'b1111) begin
                    q <= 4'b0000;
                end
                else if (q == 4'b0000) begin
                    q <= 4'b1111;
                end
                else begin
                    if (ld) begin
                        q <= data;
                    end
                    else if (q < 4'b1111 && !ld) begin
                        q <= q + 1;
                    end
                    else if (q > 4'b0000 && !ld) begin
                        q <= q - 1;
                    end
                end
            end
        end
    end

endmodule