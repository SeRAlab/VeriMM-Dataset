module top_module(

input wire [1:0] select,
input wire [7:0] ch_0,
input wire [7:0] ch_1,
input wire [7:0] ch_2,
input wire [7:0] ch_3,


output reg [7:0] data_out
);always @*
        begin
            case(select)
                2'b11: data_out = ch_0;
                2'b10: data_out = ch_1;
                2'b01: data_out = ch_2;
                2'b00: data_out = ch_3;
                default : data_out = ch_0;
            endcase
        end

endmodule