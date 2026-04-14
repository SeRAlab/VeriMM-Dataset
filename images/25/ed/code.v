module stack (
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [2:0] depth
);
    reg [7:0] stack_mem [0:7]; // 8 elements stack
    reg [2:0] top; // points to the top of the stack

    initial begin
        top = 0;
        depth = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            depth <= 0;
            data_out <= 8'b0;
        end else begin
            if (push && depth < 8) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                depth <= depth + 1;
            end
            if (pop && depth > 0) begin
                top <= top - 1;
                data_out <= stack_mem[top - 1];
                depth <= depth - 1;
            end
        end
    end
endmodule