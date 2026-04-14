module mux_4to1
    (
        input [1:0] sel,
        input data0,
        input data1,
        input data2,
        input data3,
        output reg out
    );

    always @(*) 
    begin
        case(sel)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            2'b11: out = data3;
            default: out = 1'b0;
        endcase
    end

endmodule