module counter3bit (
    input clk,
    input rst,
    output reg [2:0] count
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'b000;
    end else begin
        count <= count + 1;
    end
end

endmodule