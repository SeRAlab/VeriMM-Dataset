module stack (
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    input wire clk,
    input wire reset,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] stack_mem [0:7]; // 8 depth stack
    reg [2:0] top; // points to the top of the stack

    initial begin
        top = 3'b111; // Stack is empty initially
        empty = 1'b1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b111; // Reset the stack
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && top < 3'b111) begin
                top <= top + 1;
                stack_mem[top] <= data_in;
                empty <= 1'b0;
            end else if (pop && top > 3'b111) begin
                data_out <= stack_mem[top];
                top <= top - 1;
                if (top == 3'b111) begin
                    empty <= 1'b1; // Stack becomes empty
                end
            end
        end
    end
endmodule