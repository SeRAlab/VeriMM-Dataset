module top_module(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [1:0] OP,
    output reg [7:0] result
);always @(posedge clk) begin
        case (OP)
            2'b00: result <= A + B;
            2'b01: result <= A - B;
            2'b10: result <= A * B;
            2'b11: begin
                if (B == 0) begin
                    result <= 8'b0;
                end else begin
                    result <= A / B;
                end
            end
        endcase
    end

endmodule