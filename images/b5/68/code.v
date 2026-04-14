module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    input clk,
    output reg [7:0] result,
    output reg overflow
);reg [15:0] temp;

    always @(posedge clk) begin
        case (op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: result <= a * b;
            2'b11: begin
                if (b == 0) begin
                    result <= 8'b0;
                    overflow <= 1;
                end else begin
                    temp <= {a, 8'b0} / b;
                    if (temp > 8'b11111111) begin
                        result <= 8'b0;
                        overflow <= 1;
                    end else begin
                        result <= temp[7:0];
                        overflow <= 0;
                    end
                end
            end
        endcase
    end

endmodule