module stack (
    input clk,
    input rst_n,
    input [2:0] ctrl, // Control signal: 000=Push, 001=Pop, 010=Peek
    input [7:0] data_in, // Data to push
    output reg [7:0] data_out, // Data popped or peeked
    output reg full, // Indicates stack is full
    output reg empty // Indicates stack is empty
);
    reg [7:0] stack_mem [0:7]; // 8-element stack
    reg [2:0] top; // Points to the top of the stack

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            top <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            case (ctrl)
                3'b000: begin // Push
                    if (!full) begin
                        stack_mem[top] <= data_in;
                        top <= top + 1;
                    end
                end
                3'b001: begin // Pop
                    if (!empty) begin
                        top <= top - 1;
                        data_out <= stack_mem[top];
                    end
                end
                3'b010: begin // Peek
                    if (!empty) begin
                        data_out <= stack_mem[top - 1];
                    end
                end
            endcase
            full <= (top == 3'b111);
            empty <= (top == 3'b000);
        end
    end
endmodule