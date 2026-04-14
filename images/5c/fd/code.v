module modulo_50_counter(
    input clk,
    input rst,
    output reg [5:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 6'b0;
        end else if (q == 6'd49) begin
            q <= 6'b0;
        end else begin
            q <= q + 1;
        end
    end
endmodule