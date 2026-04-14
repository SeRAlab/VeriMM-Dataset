module d_flip_flop(
    input wire clk,
    input wire rst,
    input wire set,
    input wire d,
    output reg q
);

    always @(posedge clk or posedge rst or posedge set) begin
        if (set) begin
            q <= 1'b1;
        end else if (rst) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end
endmodule