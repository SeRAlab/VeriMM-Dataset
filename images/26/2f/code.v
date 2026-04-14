module stack (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] mem [0:7]; // memory for the stack
    reg [2:0] top; // points to the current top of the stack

    initial begin
        top = 3'b000;
        full = 1'b0;
        empty = 1'b1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (push && !full) begin
                mem[top] <= data_in;
                top <= top + 1;
                if (top + 1 == 8) full <= 1'b1;
                empty <= 1'b0;
            end
            if (pop && !empty) begin
                top <= top - 1;
                data_out <= mem[top];
                if (top - 1 < 0) empty <= 1'b1;
                full <= 1'b0;
            end
        end
    end
endmodule