module deserializer (
    input clk,
    input rst,
    input [15:0] din,
    output reg [7:0] doutA,
    output reg [7:0] doutB
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            doutA <= 8'b0;
            doutB <= 8'b0;
        end else begin
            doutA <= din[15:8];
            doutB <= din[7:0];
        end
    end
endmodule