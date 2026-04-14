module top_module(a, b, op, add_out, sub_out, mul_out, div_out);input signed [15:0] a, b;
    input [1:0] op;
    output reg signed [15:0] add_out, sub_out, mul_out, div_out;
    
    always @(*) begin
        case(op)
            2'b00: begin // addition
                add_out = a + b;
                sub_out = 16'h0000;
                mul_out = 16'h0000;
                div_out = 16'h0000;
            end
            2'b01: begin // subtraction
                add_out = 16'h0000;
                sub_out = a - b;
                mul_out = 16'h0000;
                div_out = 16'h0000;
            end
            2'b10: begin // multiplication
                add_out = 16'h0000;
                sub_out = 16'h0000;
                mul_out = a * b;
                div_out = 16'h0000;
            end
            2'b11: begin // division
                add_out = 16'h0000;
                sub_out = 16'h0000;
                mul_out = 16'h0000;
                if (b != 16'h0000) begin
                    div_out = a / b;
                end else begin
                    div_out = 16'hFFFF;
                end
            end
        endcase
    end
    
endmodule