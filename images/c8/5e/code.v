module counter_3bit (
    input clk,
    input rst,
    input en,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b0;
    end else if (en) begin
        count <= count + 3'b1;
    end
end

endmodule