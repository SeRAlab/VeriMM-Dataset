module top_module(
    input clk,
    input rst_n,
    input en,
    output reg [3:0] count_out
);always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count_out <= 4'b0;
    end else if (en) begin
        count_out <= count_out + 1;
    end
end

endmodule