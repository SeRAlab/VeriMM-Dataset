module LIFO_Stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack [0:7];
    reg [2:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 3'b000;
            empty <= 1'b1;
            full <= 1'b0;
            data_out <= 8'b0;
        end else begin
            if (push && !full) begin
                stack[top] <= data_in;
                top <= top + 1;
                if (top == 3'b111) full <= 1'b1;
                empty <= 1'b0;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack[top];
                if (top == 3'b000) empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule