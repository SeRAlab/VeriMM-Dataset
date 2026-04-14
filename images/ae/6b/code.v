module top_module(
    input [3:0] data_in,
    output reg [3:0] data_out // Change to reg type
);always @(*) begin
        case (data_in)
            4'b0000: data_out = 4'b0000;
            4'b0001: data_out = 4'b1111;
            4'b0010: data_out = 4'b0101;
            4'b0011: data_out = 4'b1010;
            4'b0100: data_out = 4'b0011;
            4'b0101: data_out = 4'b1100;
            4'b0110: data_out = 4'b0110;
            4'b0111: data_out = 4'b1001;
            4'b1000: data_out = 4'b1110;
            4'b1001: data_out = 4'b0001;
            4'b1010: data_out = 4'b1101;
            4'b1011: data_out = 4'b0010;
            4'b1100: data_out = 4'b1000;
            4'b1101: data_out = 4'b0111;
            4'b1110: data_out = 4'b1011;
            4'b1111: data_out = 4'b0100;
            default: data_out = 4'bxxxx;
        endcase
    end

endmodule