module counter(
    output reg [3:0] out,
    input clk,
    input reset
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 4'd0;
        end else begin
            out <= out + 1;
        end
    end

endmodule