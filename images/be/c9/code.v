module palindrome_check_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg is_palindrome
);

    always @(posedge clk) begin
        if (reset) begin
            is_palindrome <= 0;
        end else begin
            if ((binary_num[7] == binary_num[0]) && 
                (binary_num[6] == binary_num[1]) && 
                (binary_num[5] == binary_num[2]) && 
                (binary_num[4] == binary_num[3])) begin
                is_palindrome <= 1;
            end else begin
                is_palindrome <= 0;
            end
        end
    end

endmodule