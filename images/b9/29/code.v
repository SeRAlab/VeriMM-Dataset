module async_counter(
    input clk,
    input rst_n,
    output reg [2:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 3'b000;
        end else begin
            count <= count + 1;
        end
    end
endmodule