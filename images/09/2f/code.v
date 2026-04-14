module divide_by_2 (
    input wire clk,
    input wire rst,
    output reg q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 0;
    end else begin
        q <= ~q;
    end
end

endmodule