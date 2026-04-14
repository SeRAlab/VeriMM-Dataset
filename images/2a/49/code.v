module stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty
);
    reg [7:0] stack_mem [0:7]; // 8-deep stack
    reg [2:0] top; // points to the current top of the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'd0; // reset stack
            is_empty <= 1'b1; // stack is empty
        end else begin
            if (push && top < 3'd8) begin
                stack_mem[top] <= data_in; // push data onto stack
                top <= top + 1; // increment top
                is_empty <= 1'b0; // stack is not empty
            end
            if (pop && top > 3'd0) begin
                top <= top - 1; // decrement top
                data_out <= stack_mem[top - 1]; // output the popped data
                is_empty <= (top - 1 == 3'd0); // check if stack is empty
            end
            if (!pop && top > 3'd0) begin
                data_out <= stack_mem[top - 1]; // peek at the top
            end
        end
    end
endmodule