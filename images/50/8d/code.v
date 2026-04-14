module sync_counter_with_enable(
    input clk,
    input en,
    output reg [9:0] q
    );

    always @(posedge clk) begin
        if (en) begin
            q <= q + 1;
        end
    end
endmodule