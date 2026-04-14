module top_module(input clk, rst, up_down,
     output reg [1:0] count);always @(posedge clk) begin
        if (rst) begin
            count <= 2'b0;
        end else if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule