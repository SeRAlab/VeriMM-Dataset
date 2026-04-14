module divide_by_4 (
    input clk,
    input rst,
    input [1:0] in,
    output reg out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            if (in == 2'b00) begin
                out <= 1; // 0 is divisible by 4
            end else if (in == 2'b01) begin
                out <= 0; // 1 is not divisible by 4
            end else if (in == 2'b10) begin
                out <= 0; // 2 is not divisible by 4
            end else if (in == 2'b11) begin
                out <= 0; // 3 is not divisible by 4
            end
        end
    end
endmodule