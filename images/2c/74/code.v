module stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem [0:7];
    reg [2:0] top; // Points to the next empty position

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b000;
            empty <= 1;
            full <= 0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
            end
            empty <= (top == 3'b000);
            full <= (top == 3'b100);
        end
    end
endmodule