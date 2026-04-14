module counter_3bit (
    input clk,
    input reset,
    output reg [2:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 3'b000;
        end else begin
            out <= out + 1;
        end
    end

endmodule