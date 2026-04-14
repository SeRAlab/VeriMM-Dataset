module up_counter_with_enable_async_reset(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b00000;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule