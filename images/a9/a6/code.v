module top_module(
    input clk,
    input [3:0] binary,
    output reg [3:0] gray
);// 8 D flip-flops designed using a shift register architecture
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[2:0], binary};
    end

    // 2-input AND gate using NOR gates
    wire and_out;
    wire nor1, nor2;

    // Implementing AND using NOR gates
    assign nor1 = ~(shift_reg[0] | shift_reg[1]);
    assign nor2 = ~(nor1 | nor1);
    assign and_out = ~(nor2 | nor2);

    // Feedback loop for binary to Gray code conversion
    always @(posedge clk) begin
        gray <= {shift_reg[3] ^ shift_reg[2], shift_reg[2] ^ shift_reg[1], shift_reg[1] ^ shift_reg[0], shift_reg[0]};
    end

endmodule