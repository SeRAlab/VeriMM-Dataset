module top_module(
    input wire clk,
    input wire reset_b,
    input wire enable,
    output reg [3:0] count,
    output reg overflow
);always @(posedge clk) begin
        if (reset_b == 1'b0) begin
            count <= 4'b0000;
            overflow <= 1'b0;
        end else if (enable == 1'b1) begin
            if (count == 4'b1111) begin
                count <= 4'b0000;
                overflow <= 1'b1;
            end else begin
                count <= count + 1;
                overflow <= 1'b0;
            end
        end
    end

endmodule