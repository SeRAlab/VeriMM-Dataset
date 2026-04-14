module timer_32bit (
    input clk,
    input rst,
    input enable,
    output reg [31:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'b0;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule