module top_module(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [3:0] count
);always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end
    else if (en) begin
        count <= count + 1;
    end
end

endmodule