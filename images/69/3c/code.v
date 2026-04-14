module sync_counter_8bit(
    input clk,
    input rst,
    input en,
    output reg [7:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (en) begin
            q <= q + 1;
        end
    end
endmodule