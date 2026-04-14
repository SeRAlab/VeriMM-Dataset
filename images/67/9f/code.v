module top_module(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else if (enable) begin
            if (load) begin
                count <= d;
            end else begin
                count <= count + 4'b1;
            end
        end
    end

endmodule