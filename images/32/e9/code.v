module stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg empty
);
    reg [3:0] stack_mem [3:0];
    reg [1:0] top; // Points to the top element in the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 2'b00;
            empty <= 1'b1;
            data_out <= 4'b0000;
        end else begin
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 1) empty <= 1'b1; // Update empty status
            end
            if (push && top < 4) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0; // Clear empty status
            end
        end
    end
endmodule