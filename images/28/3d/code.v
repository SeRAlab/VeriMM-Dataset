module timer(
    input clk,
    input rst_n,
    input enable,
    output reg [31:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 32'b0;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule