module sync_down_counter(
    input clk,
    input rst,
    output reg [7:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'hFF;
        end else begin
            q <= q - 1;
        end
    end
endmodule