module counter_64bit (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [63:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 64'b0;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule