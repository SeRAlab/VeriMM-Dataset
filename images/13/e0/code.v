module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] stack_mem [3:0]; // 4 depth stack
    reg [1:0] top; // points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                if (top == 2'b11) full <= 1'b1;
                empty <= 1'b0;
            end else if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 2'b00) empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule