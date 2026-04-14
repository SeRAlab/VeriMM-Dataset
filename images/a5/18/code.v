module top_module(
    input clk,
    input reset,
    input [1:0] op,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);always @(posedge clk) begin
        if (reset) begin
            result <= 0;
        end else begin
            case (op)
                2'b00: // addition
                    if ((a[7] == 1 && b[7] == 1 && result[7] == 0) || 
                        (a[7] == 0 && b[7] == 0 && result[7] == 1)) begin
                        // overflow
                        result <= 8'hFF;
                    end else if ((a[7] == 0 && b[7] == 0 && result[7] == 0) || 
                                   (a[7] == 1 && b[7] == 1 && result[7] == 1)) begin
                        // no overflow
                        result <= a + b;
                    end else begin
                        // underflow
                        result <= 8'h00;
                    end
                2'b01: // subtraction
                    if ((a[7] == 0 && b[7] == 1 && result[7] == 0) || 
                        (a[7] == 1 && b[7] == 0 && result[7] == 1)) begin
                        // overflow
                        result <= 8'hFF;
                    end else if ((a[7] == 0 && b[7] == 1 && result[7] == 1) || 
                                   (a[7] == 1 && b[7] == 0 && result[7] == 0)) begin
                        // no overflow
                        result <= a - b;
                    end else begin
                        // underflow
                        result <= 8'h00;
                    end
                2'b10: // multiplication
                    result <= a * b;
                2'b11: // division
                    if (b == 8'h00) begin
                        // division by zero
                        result <= 8'hFF;
                    end else begin
                        result <= a / b;
                    end
                default: // unknown operation
                    result <= 8'hFF;
            endcase
        end
    end

endmodule