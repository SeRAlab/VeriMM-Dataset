module top_module(
    input clk,        // Added the clk input
    input rst,
    input en,
    output reg [3:0] count
);always @ (posedge clk or negedge rst) begin
        if (rst == 0) begin
            count <= 4'b0000;
        end else if (en == 1) begin
            count <= count + 1;
        end
    end

endmodule