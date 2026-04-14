module down_counter(
    input clk,
    input rst_n,
    output reg [4:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 5'b11111;
        end else begin
            count <= count - 1;
        end
    end
endmodule