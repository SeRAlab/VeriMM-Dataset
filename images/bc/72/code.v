module top_module(input signed [7:0] a, b, input [1:0] op, output reg [7:0] result, output reg error);always @(*) begin
    case(op)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a * b;
        2'b11: begin
            if(b == 0) begin
                error = 1;
                result = 8'h00;
            end
            else begin
                error = 0;
                result = a / b;
            end
        end
        default: result = 8'h00;
    endcase
    // check for overflow in addition and subtraction
    if(op == 2'b00 || op == 2'b01) begin
        if((a[7] == b[7]) && (result[7] != a[7])) begin
            error = 1;
        end
        else begin
            error = 0;
        end
    end
end

endmodule