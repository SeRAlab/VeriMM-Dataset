module top_module(
    A,
    B,
    op,
    result
);input [7:0] A;
    input [7:0] B;
    input [1:0] op;
    output reg [7:0] result; // Change to reg

    reg [15:0] temp; // Change to reg

    always @* begin
        case (op)
            2'b00: result = A + B; // addition
            2'b01: result = A - B; // subtraction
            2'b10: begin // multiplication
                temp = A * B;
                result = temp[7:0];
            end
            2'b11: begin // division
                if (B == 8'b0) begin
                    result = 8'b0;
                end else begin
                    result = A / B;
                end
            end
            default: result = 8'b0;
        endcase
    end

endmodule