module zero_detector(
    input clk,
    input reset,
    input [3:0] in,
    output reg out);

    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (in == 4'b0000) ? 1'b1 : 1'b0;
    end
endmodule