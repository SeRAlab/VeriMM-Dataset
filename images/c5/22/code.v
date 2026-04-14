module counter (
    input clk,
    input reset,
    output reg [3:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 4'b0000;
        end else begin
            if (out == 4'b1111) begin
                out <= 4'b0000;
            end else begin
                out <= out + 1;
            end
        end
    end

endmodule