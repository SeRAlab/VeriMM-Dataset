module counter(
    input clk,
    input rst,
    input en,
    output reg [2:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 0;
    end else if (en) begin
        out <= out + 1;
    end
end

endmodule