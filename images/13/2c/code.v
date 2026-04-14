module stack (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] stack_mem [3:0];
    reg [1:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 2'b00;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (push && top < 2'b11) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
            end
            if (pop && top > 2'b00) begin
                top <= top - 1;
                data_out <= stack_mem[top-1];
                if (top == 2'b01) begin
                    empty <= 1'b1;
                end
            end
        end
    end
endmodule