module down_counter (
    input clk,
    input rst_n,
    input en,
    input [4:0] init_val,
    output reg [4:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= init_val;
        end else if (en && count > 0) begin
            count <= count - 1;
        end
    end
endmodule