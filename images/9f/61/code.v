module sync_counter_12bit(
    input clk,
    input rst,
    input mode,
    output reg [11:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 12'b000000000000;
        end else if (mode) begin
            q <= q + 1;
        end else begin
            q <= q - 1;
        end
    end
endmodule