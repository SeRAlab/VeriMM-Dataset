module counter4bit_ud (
    input clk,
    input rst,
    input up_down,
    output reg [3:0] count
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b0000;
    end else if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule