module d_ff (
    input wire clk,
    input wire rst,
    input wire en,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0;
        end else if (en) begin
            q <= d;
        end
    end
endmodule