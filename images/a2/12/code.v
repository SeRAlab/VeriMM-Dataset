module top_module(input wire [3:0] in, input wire [1:0] s, output wire out);reg [3:0] temp;
    always @(in or s)
        case (s)
            2'b00: temp = in[0];
            2'b01: temp = in[1];
            2'b10: temp = in[2];
            2'b11: temp = in[3];
            default: temp = 4'b0;
        endcase
    assign out = temp;
endmodule