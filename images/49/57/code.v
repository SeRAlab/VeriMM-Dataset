module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);always @(posedge clk) begin
    if (reset == 0) begin
        count <= 0;
    end else if (enable == 1) begin
        if (count == 15) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule