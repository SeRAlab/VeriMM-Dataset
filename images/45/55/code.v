module async_up_counter(
    input clk,
    input rst,
    output reg [11:0] q
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 12'b000000000000;
        end else begin
            q <= q + 1;
        end
    end
endmodule