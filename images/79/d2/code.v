module down_counter_with_reset (
    input clk,
    input en,
    input rst,
    output reg [3:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b1111;
        end else if (en) begin
            count <= count - 1;
        end
    end
endmodule