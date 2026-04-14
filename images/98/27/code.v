module top_module(clk, rst, op, a, b, result, overflow, zero, valid);input clk, rst, op;
    input [7:0] a, b;
    output reg [7:0] result;
    output reg overflow, zero, valid;
    
    always @(posedge clk) begin
        if (rst) begin
            result <= 8'b0;
            overflow <= 1'b0;
            zero <= 1'b0;
            valid <= 1'b0;
        end else begin
            case (op)
                2'b00: begin // Addition
                    result <= a + b;
                    overflow <= (a[7] == b[7] && result[7] != a[7]);
                    zero <= (result == 8'b0);
                    valid <= 1'b1;
                end
                2'b01: begin // Subtraction
                    result <= a - b;
                    overflow <= (a[7] != b[7] && result[7] != a[7]);
                    zero <= (result == 8'b0);
                    valid <= 1'b1;
                end
                2'b10: begin // Multiplication
                    result <= a * b;
                    overflow <= (result[15:8] != 8'b0);
                    zero <= (result == 8'b0);
                    valid <= 1'b1;
                end
                2'b11: begin // Division
                    if (b == 8'b0) begin
                        result <= 8'b0;
                        overflow <= 1'b0;
                        zero <= 1'b1;
                        valid <= 1'b1;
                    end else begin
                        result <= a / b;
                        overflow <= (result[7:0] != a[7:0]);
                        zero <= (result == 8'b0);
                        valid <= 1'b1;
                    end
                end
            endcase
        end
    end
endmodule