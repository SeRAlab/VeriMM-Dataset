module top_module(
    data0x,
    data1x,
    data2x,
    sel,
    result
);input  [21:0]  data0x;
    input  [21:0]  data1x;
    input  [21:0]  data2x;
    input  [1:0]   sel;
    output reg [21:0]  result; // Changed to output reg

    always @(*) begin
        case (sel)
            2'b00: result = data0x;
            2'b01: result = data1x;
            2'b10: result = data2x;
            default: result = 22'hx; // undefined behavior
        endcase
    end

endmodule