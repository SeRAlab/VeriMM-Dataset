module top_module(
    input [3:0] load,
    input enable,
    input reset,
    input clk,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else if (enable) begin
            if (load) begin
                count <= load;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule