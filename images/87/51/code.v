module top_module(
    input clk,
    input up_down,
    input rst,
    output reg [2:0] count
);always @(posedge clk) begin
        if (rst) begin
            count <= 3'b0;
        end
        else begin
            if (up_down) begin
                count <= count + 1;
            end
            else begin
                count <= count - 1;
            end
        end
    end

endmodule