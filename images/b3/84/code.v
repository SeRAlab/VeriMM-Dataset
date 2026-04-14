module top_module(
    input [5:0] op,
    input [5:0] func,
    output reg [4:0] aluc
);always @* begin
        case(op)
            6'b000000: begin
                case(func)
                    6'b100000: aluc = 0;
                    6'b100001: aluc = 1;
                    6'b100010: aluc = 2;
                    6'b100011: aluc = 3;
                    6'b100100: aluc = 4;
                    6'b100101: aluc = 5;
                    6'b100110: aluc = 6;
                    6'b100111: aluc = 7;
                    6'b101010: aluc = 8;
                    6'b101011: aluc = 9;
                    6'b000000: aluc = 10;
                    6'b000010: aluc = 11;
                    6'b000011: aluc = 12;
                    6'b000100: aluc = 10;
                    6'b000110: aluc = 11;
                    6'b000111: aluc = 12;
                    6'b000001: aluc = 13;
                    6'b000010: aluc = 13;
                    default: aluc = 0;
                endcase
            end
            6'b001000: aluc = 0;
            6'b001001: aluc = 1;
            6'b001100: aluc = 4;
            6'b001101: aluc = 5;
            6'b001110: aluc = 6;
            6'b001010: aluc = 8;
            6'b001011: aluc = 9;
            6'b001111: aluc = 14;
            default: aluc = 0;
        endcase
    end

endmodule