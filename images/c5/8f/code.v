module binary_counter (
    input clk,
    input reset,
    output reg [3:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 4'b0;
        end else begin
            out <= out + 1;
        end
    end

endmodule