module sync_down_counter_4bit(
    input clk,
    input en,
    output reg [3:0] q
    );

    always @(posedge clk) begin
        if (en) begin
            q <= q - 1;
        end
    end
endmodule