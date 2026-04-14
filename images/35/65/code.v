module stack #(parameter SIZE=8) (
    input wire clk,
    input wire reset,
    input wire push,
    input wire pop,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_mem [0:SIZE-1];
    reg [3:0] top;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            top <= 4'b0;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (push && !full) begin
                stack_mem[top] <= data_in;
                top <= top + 1;
                empty <= 1'b0;
                if (top + 1 == SIZE) full <= 1'b1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_mem[top];
                if (top == 1) empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule