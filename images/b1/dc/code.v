module top_module(input clk, rst, en, output reg [1:0] count);always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            count <= 2'b00;
        end else if (en == 1) begin
            if (count == 2'b11) begin
                count <= 2'b00;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule