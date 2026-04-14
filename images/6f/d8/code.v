module top_module(
    input clk,
    input rst,
    input up_down,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 4'b0;
        end
        else if (load) begin
            count <= data_in;
        end
        else if (up_down) begin
            count <= count + 1;
        end
        else begin
            count <= count - 1;
        end
    end

endmodule