module ones_counter(
    input [3:0] in,
    input clk,
    input rst,
    output reg [2:0] out
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 0;
        end else begin
            out <= (in[0] + in[1] + in[2] + in[3]);
        end
    end

endmodule