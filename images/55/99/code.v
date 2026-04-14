module reg_with_enable (
    input clk,
    input rst,
    input en,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'd0;
        end else if (en) begin
            q <= d;
        end
    end

endmodule