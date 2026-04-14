module counter_4bit (
    input wire clk,
    input wire rst,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else begin
            q <= q + 1;
        end
    end

endmodule