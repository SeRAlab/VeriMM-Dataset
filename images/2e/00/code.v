module down_counter (
    input clk,
    input reset,
    input enable,
    input [3:0] preset,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= preset;
        end else if (enable) begin
            count <= count - 1;
        end
    end
endmodule