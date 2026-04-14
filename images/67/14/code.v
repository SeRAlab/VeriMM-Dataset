module top_module(
    input clk,
    input rst,
    input en,
    input mode,
    output reg [3:0] count
);always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (en) begin
            if (mode) begin
                // Down-counting mode
                if (count == 4'b0000) begin
                    count <= 4'b1111;
                end else begin
                    count <= count - 1;
                end
            end else begin
                // Up-counting mode
                if (count == 4'b1111) begin
                    count <= 4'b0000;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule