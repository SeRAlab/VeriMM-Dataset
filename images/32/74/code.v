module LIFO_Stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [3:0] data_in,
    output reg [3:0] stack_out,
    output reg [2:0] depth,
    output reg overflow,
    output reg underflow
);
    reg [3:0] stack [7:0]; // 8 depth stack
    reg [2:0] top; // points to the current top of the stack

    initial begin
        top = 3'b000;
        overflow = 0;
        underflow = 0;
        depth = 3'b000;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b000;
            depth <= 3'b000;
            overflow <= 0;
            underflow <= 0;
        end else begin
            if (push && (top < 3'b111)) begin // Check for overflow
                stack[top] <= data_in;
                top <= top + 1;
                depth <= depth + 1;
                overflow <= 0;
            end else if (push) begin
                overflow <= 1; // Overflow condition
            end
            
            if (pop && (top > 3'b000)) begin // Check for underflow
                top <= top - 1;
                stack_out <= stack[top - 1];
                depth <= depth - 1;
                underflow <= 0;
            end else if (pop) begin
                underflow <= 1; // Underflow condition
            end
        end
    end
endmodule