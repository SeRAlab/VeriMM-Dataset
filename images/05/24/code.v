module LIFOStack #(parameter WIDTH = 8, DEPTH = 4) (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg empty,
    output reg full
);
    reg [WIDTH-1:0] stack [0:DEPTH-1];
    reg [3:0] top; // Pointer to the top of the stack

    initial begin
        top = 0;
        empty = 1;
        full = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                empty <= (top == 0);
                full <= (top + 1 == DEPTH);
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top - 1];
                empty <= (top - 1 == 0);
                full <= 0; // Pop operation can't cause full
            end
        end
    end
endmodule