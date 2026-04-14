module gray_code_counter (
    input clk,
    input rst,
    input en,
    output reg [3:0] gray_count);

    always @(posedge clk) begin
        if (rst) begin
            gray_count <= 4'b0;
        end else if (en) begin
            gray_count <= gray_count ^ (gray_count >> 1) + 1;
        end
    end
endmodule