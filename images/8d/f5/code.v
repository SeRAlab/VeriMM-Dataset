module gray_code_counter (
    input clk,
    input sreset,
    input en,
    output reg [2:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 3'b000;
        end else if (en) begin
            count <= (count >> 1) ^ count;
        end
    end
endmodule