module divider_4bit (
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    input wire clk,
    input wire rst
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
        end else begin
            if (divisor != 4'b0000) begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end else begin
                quotient <= 4'b0000;
                remainder <= 4'b0000;
            end
        end
    end
endmodule