module dfs_stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg empty
);
    reg [3:0] stack [0:15]; // 16 elements stack
    reg [3:0] top; // points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 4'b0000;
            empty <= 1'b1;
        end else begin
            if (push && top < 4'd16) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
            end else if (pop && top > 0) begin
                top <= top - 1;
                data_out <= stack[top];
                empty <= (top == 1);
            end
        end
    end
endmodule