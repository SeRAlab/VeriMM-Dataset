module top_module(
    input wire clk,
    input wire reset,
    output reg [3:0] count,
    output reg wrap_around
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            wrap_around <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 4'hF) begin
                wrap_around <= 1'b1;
            end else begin
                wrap_around <= 1'b0;
            end
        end
    end

endmodule