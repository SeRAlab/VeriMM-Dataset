module stack(
    input clk,
    input rst,
    input [7:0] data_in,
    input push,
    input pop,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] stack_mem [0:7]; // Stack memory
    reg [2:0] top; // Stack pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            empty <= 1'b1;
            data_out <= 8'b00000000;
        end else begin
            if (push && top < 3'b111) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
            end 
            if (pop && top > 3'b000) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 3'b001) begin
                    empty <= 1'b1;
                end
            end
        end
    end
endmodule