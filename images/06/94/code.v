module divider_4bit (
    input clk,
    input rst_n,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_A;
    reg [3:0] temp_B;
    reg [3:0] temp_quotient;
    reg [3:0] temp_remainder;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 1'b0;
        end else if (count < 4) begin
            if (count == 0) begin
                temp_A <= A;
                temp_B <= B;
                temp_quotient <= 4'b0000;
                temp_remainder <= A;
                done <= 1'b0;
            end else if (temp_remainder >= temp_B) begin
                temp_remainder <= temp_remainder - temp_B;
                temp_quotient <= temp_quotient + 1;
            end
            count <= count + 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_remainder;
            done <= 1'b1;
        end
    end
endmodule