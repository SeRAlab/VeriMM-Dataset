module crystal_oscillator (
    input clk,
    input rst,
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            out <= ~out;
        end
    end
endmodule