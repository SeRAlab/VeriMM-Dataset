module top_module(
    input clk,
    input start,
    output reg [2:0] count
);always @(posedge clk) begin
        if (start) begin
            if (count == 7) begin
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end

endmodule