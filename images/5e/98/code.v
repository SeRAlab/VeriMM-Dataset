module top_module(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [7:0] count);

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b0;
        end else if (enable) begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule