module divide_by_2 (
    input clk,
    input rst_n,
    input din,
    output reg dout
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 1'b0;
        end else begin
            dout <= din;
        end
    end
endmodule