module lifo_stack #(parameter DATA_WIDTH = 8, parameter STACK_DEPTH = 16) (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [DATA_WIDTH-1:0] stack [0:STACK_DEPTH-1];
    reg [3:0] top; // Points to the top of the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            is_empty <= 1;
            is_full <= 0;
            data_out <= 0;
        end else begin
            if (push && !is_full) begin
                stack[top] <= data_in;
                top <= top + 1;
                is_empty <= 0;
                if (top + 1 == STACK_DEPTH) is_full <= 1;
            end
            
            if (pop && !is_empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 1) is_empty <= 1;
                is_full <= 0;
            end
        end
    end
endmodule