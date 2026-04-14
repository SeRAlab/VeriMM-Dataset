module top_module(
    input [4:0] ctrl,
    input [15:0] data_in_A,
    input [15:0] data_in_B,
    output reg [15:0] data_out
    );always @* begin
        case(ctrl)
            1: data_out = data_in_A + data_in_B;
            2: data_out = data_in_A - data_in_B;
            3: data_out = data_in_A & data_in_B;
            4: data_out = data_in_A | data_in_B;
            5: data_out = data_in_A ^ data_in_B;
            6: data_out = ~data_in_A;
            7: data_out = ~data_in_B;
            8: data_out = data_in_A << 1;
            9: data_out = data_in_A >> 1;
            10: data_out = data_in_B << 1;
            11: data_out = data_in_B >> 1;
            12: data_out = (data_in_A == data_in_B) ? 1 : 0;
            13: data_out = (data_in_A < data_in_B) ? 1 : 0;
            14: data_out = (data_in_A > data_in_B) ? 1 : 0;
            15: data_out = (data_in_A <= data_in_B) ? 1 : 0;
            16: data_out = (data_in_A >= data_in_B) ? 1 : 0;
            default: data_out = 0;
        endcase
    end

endmodule