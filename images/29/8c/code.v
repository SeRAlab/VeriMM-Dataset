module stack (
    input clk,
    input reset,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg underflow
);
    reg [7:0] stack_mem [0:3];
    reg [1:0] top; // Points to the top of the stack

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 2'b00;
            underflow <= 0;
            data_out <= 8'b0;
        end else begin
            if (push) begin
                if (top < 4) begin
                    stack_mem[top] <= data_in;
                    top <= top + 1;
                    underflow <= 0;
                end
            end
            if (pop) begin
                if (top > 0) begin
                    top <= top - 1;
                    data_out <= stack_mem[top - 1];
                    underflow <= 0;
                end else begin
                    underflow <= 1; // Underflow condition
                end
            end
        end
    end
endmodule