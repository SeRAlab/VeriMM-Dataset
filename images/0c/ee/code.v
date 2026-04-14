module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg empty
);
    reg [3:0] stack_mem [0:3]; // Stack memory
    reg [1:0] top; // Points to the top of the stack

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            empty <= 1'b1;
            data_out <= 4'b0000;
        end else begin
            if (push && (top < 2'b11)) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
            end
            if (pop && (top > 2'b00)) begin
                top <= top - 1;
                data_out <= stack_mem[top - 1];
                if (top == 2'b01) empty <= 1'b1;
            end
        end
    end
endmodule