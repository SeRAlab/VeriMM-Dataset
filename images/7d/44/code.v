module sync_up_counter_5bit(
    input clk,
    input rst,
    output reg [4:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 5'b00000;
        end else begin
            q <= q + 1;
        end
    end
endmodule