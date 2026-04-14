module decoder_2to4(en, a, y);

    input en;
    input [1:0] a;
    output [3:0] y;
    reg [3:0] y;

    always @(en or a)
    begin
        if (en)
            case (a)
                2'b00: y = 4'b0001;
                2'b01: y = 4'b0010;
                2'b10: y = 4'b0100;
                2'b11: y = 4'b1000;
                default: y = 4'b0000;
            endcase
        else
            y = 4'b0000;
    end

endmodule