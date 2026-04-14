module top_module(
    input [3:0] a,
    input [3:0] b,
    input [1:0] c,
    input d,
    input e,
    output reg x
);reg [4:0] sum;
    reg [1:0] index;
    reg selected_bit;

    always @(*) begin
        sum = a + b;
        case (c)
            2'b00: index = 2'b00;
            2'b01: index = 2'b01;
            2'b10: index = 2'b10;
            2'b11: index = 2'b11;
        endcase
        selected_bit = sum[index];
        if (d == 1) begin
            selected_bit = ~selected_bit;
        end
        if (e == 1) begin
            x = selected_bit;
        end else begin
            x = d;
        end
    end

endmodule