module counter11bit_term (
    input clk,
    input rst,
    input en,
    output reg [10:0] count,
    output reg term_count
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 11'b00000000000;
        term_count <= 0;
    end else if (en) begin
        if (count == 11'b11111111111) begin
            count <= 11'b00000000000;
            term_count <= 1;
        end else begin
            count <= count + 1;
            term_count <= 0;
        end
    end
end

endmodule