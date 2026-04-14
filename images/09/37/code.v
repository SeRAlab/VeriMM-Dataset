module stack (
    input clk,
    input rst,
    input [7:0] push_data,
    input push,
    input pop,
    output reg [7:0] pop_data,
    output reg empty
);
    reg [7:0] memory [7:0]; // 8 elements stack
    reg [2:0] top; // stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            empty <= 1'b1;
        end else begin
            if (push && top < 3'd8) begin
                memory[top] <= push_data;
                top <= top + 1;
                empty <= 1'b0;
            end 
            if (pop && top > 3'd0) begin
                top <= top - 1;
                pop_data <= memory[top];
                if (top == 3'd1)
                    empty <= 1'b1;
            end
        end
    end
endmodule