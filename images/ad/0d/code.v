module top_module(
    input [7:0] a,
    input [7:0] b,
    input [3:0] operation,
    input [2:0] shift_amount,
    output reg [7:0] result,
    output reg zero,
    output reg negative,
    output reg overflow
);reg [8:0] temp; // extra bit for overflow detection

    always @* begin
        case(operation)
            0: begin // addition
                temp = a + b;
                result = temp[7:0];
                overflow = (a[7] == b[7] && temp[8] != a[7]) ? 1 : 0;
            end

            1: begin // subtraction
                temp = a - b;
                result = temp[7:0];
                overflow = (a[7] != b[7] && temp[8] == b[7]) ? 1 : 0;
            end

            2: begin // bitwise AND
                result = a & b;
                overflow = 0;
            end

            3: begin // bitwise OR
                result = a | b;
                overflow = 0;
            end

            4: begin // bitwise XOR
                result = a ^ b;
                overflow = 0;
            end

            5: begin // left shift
                result = a << shift_amount;
                overflow = 0;
            end

            6: begin // right shift
                result = a >> shift_amount;
                overflow = 0;
            end

            7: begin // arithmetic right shift
                if(a[7] == 0) begin
                    result = a >> shift_amount;
                    overflow = 0;
                end else begin
                    result = (a >> shift_amount) | (~{8'b0} << (8 - shift_amount)); // Fill with 1s
                    overflow = 0;
                end
            end
        endcase

        zero = (result == 0) ? 1 : 0;
        negative = result[7];
    end

endmodule