module down_counter_with_reset(
    input clk,
    input reset,
    output reg [7:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b11111111;
        end else begin
            count <= count - 1;
        end
    end
endmodule