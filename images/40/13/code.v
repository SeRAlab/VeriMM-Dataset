module stack #(parameter SIZE = 8) (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] stack_array [0:SIZE-1];
    reg [3:0] top;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 0;
        end else begin
            if (push && !full) begin
                stack_array[top] <= data_in;
                top <= top + 1;
                empty <= 0;
                if (top + 1 == SIZE)
                    full <= 1;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= stack_array[top];
                if (top == 1)
                    empty <= 1;
                full <= 0;
            end
        end
    end
endmodule