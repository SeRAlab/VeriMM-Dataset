module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [3:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 4'b0000;
        end else if (up_down) begin
            out <= out + 1;
        end else begin
            out <= out - 1;
        end
    end

endmodule