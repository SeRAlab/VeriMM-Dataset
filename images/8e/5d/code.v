module top_module(
    input clk,
    input clear,
    input load,
    input up_down,
    input [3:0] data,
    output reg [3:0] count
);always @ (posedge clk) begin
        if (clear) begin
            count <= 4'b0;
        end else if (load) begin
            count <= data;
        end else if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule