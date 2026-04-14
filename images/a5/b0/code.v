module sync_up_counter_6bit(
    input clk,
    input rst,
    output reg [5:0] q,
    output tc
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 6'b000000;
        end else begin
            q <= q + 1;
        end
    end

    assign tc = (q == 6'b111111) ? 1'b1 : 1'b0;
endmodule