module twos_complement (
    input clk,
    input rst_n,
    input en,
    input [3:0] in,
    output reg [3:0] out
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out <= 4'b0000;
        end else if (en) begin
            out <= (~in) + 4'b0001;
        end
    end

endmodule