module top_module(
    input clk,
    input rst,
    input enable,
    input load,
    input increment,
    input [7:0] data_in,
    output reg [7:0] count
);always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else if (load) begin
            count <= data_in;
        end else if (enable && increment) begin
            count <= count + 1;
        end
    end

endmodule