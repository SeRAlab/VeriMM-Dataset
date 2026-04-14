module down_counter_with_enable(
    input clk,
    input reset,
    input enable,
    output reg [5:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 6'b111111;
        end else if (enable) begin
            count <= count - 1;
        end
    end
endmodule