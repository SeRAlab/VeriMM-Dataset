module divide_by_2 (
    input wire clk,
    input wire rst,
    input wire din,
    output reg dout
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 1'b0;
        end else begin
            dout <= din;
        end
    end

endmodule