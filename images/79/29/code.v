module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input [1:0] OP,
    output reg signed [7:0] Y,
    output reg FLAG
);always @(*) begin
    case (OP)
        2'b00: Y = A + B; // addition
        2'b01: Y = A - B; // subtraction
        2'b10: Y = A * B; // multiplication
        2'b11: begin       // division
            if (B == 0) begin
                Y = 8'h00;
                FLAG = 1;
            end else begin
                Y = A / B;
                FLAG = 0;
            end
        end
    endcase
    
    // check for overflow
    if ((OP == 2'b00 && ((A > 0 && B > 0 && Y < 0) || (A < 0 && B < 0 && Y > 0)))
        || (OP == 2'b01 && ((A > 0 && B < 0 && Y < 0) || (A < 0 && B > 0 && Y > 0)))) begin
        FLAG = 1;
    end else begin
        FLAG = 0;
    end
end

endmodule