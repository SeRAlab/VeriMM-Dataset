module counter(clk, rst, count);

input clk, rst;
output reg [3:0] count;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 4'b0000;
    end else begin
        if(count == 4'b1111) begin
            count <= 4'b0000;
        end else begin
            count <= count + 4'b0001;
        end
    end
end

endmodule