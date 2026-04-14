module top_module(
    input [3:0] in,
    input rst,
    output reg [3:0] out
);always @ (in or rst) begin
        if (rst) begin
            out <= 4'b0;
        end else begin
            out <= {in[3:2], 2'b0};
        end
    end

endmodule