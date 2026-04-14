module divide_by_8(
    input clk,
    input rst,
    output reg [2:0] q
);
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
            q <= 3'b000;
        end else begin
            if (count == 3'b111) begin
                count <= 3'b000;
                q <= q + 1;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule