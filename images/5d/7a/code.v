module counter_3bit (
    input clk,
    input rst,
    output reg [2:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 3'b000;
        end else begin
            q <= q + 1;
        end
    end

endmodule