module stack (
    input clk,
    input rst,
    input [7:0] data_in,
    input push,
    input pop,
    input peek,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem [0:3];
    reg [1:0] top; // Points to the index of the top element
    
    // Initialize the stack
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 2'b00;
            empty <= 1;
            full <= 0;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top + 1 == 4) full <= 1;
            end
            
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 1) empty <= 1;
                full <= 0;
            end
            
            if (peek && !empty) begin
                data_out <= stack_mem[top - 1];
            end
        end
    end
endmodule