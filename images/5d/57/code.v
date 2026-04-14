module top_module(
    input clk,
    input cein,
    input [1:0] divisor,
    output ceout
);reg ceoutmux;
    reg [2:0] counter;

    initial counter = 0;

    assign ceout = ceoutmux;

    always @(posedge clk) begin
        if(cein)
            counter <= counter + 1;
    end

    always @(*) begin
        case(divisor)
            2'b00:
                ceoutmux <= cein;
            2'b01:
                ceoutmux <= cein & counter[0];
            2'b10: 
                ceoutmux <= cein & counter[0] & counter[1];
            2'b11:
                ceoutmux <= cein & counter[0] & counter[1] & counter[2];
            default:
                ceoutmux <= 1'bx;
        endcase
    end

endmodule