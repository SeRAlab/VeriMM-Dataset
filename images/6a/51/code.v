module UpDownCounter (
    input clk,
    input rst,
    input enable,
    input direction,
    output reg [2:0] counter_out
);
    always @(posedge clk) begin
        if (rst) begin
            counter_out <= 3'b000;
        end else if (enable) begin
            if (direction) begin
                counter_out <= counter_out + 1;
            end else begin
                counter_out <= counter_out - 1;
            end
        end
    end
endmodule