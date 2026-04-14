module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input signed [3:0] a,
    input signed [3:0] b,
    output reg signed [3:0] result,
    output reg overflow
);reg signed [4:0] temp;

always @(posedge clk) begin
    if(rst) begin
        result <= 4'b0;
        overflow <= 1'b0;
    end else begin
        case(op)
            2'b00: begin // addition
                temp = a + b;
                if(temp > 4'b0111 || temp < -4'b1000) begin
                    overflow <= 1'b1;
                end else begin
                    overflow <= 1'b0;
                end
                result <= temp[3:0];
            end
            2'b01: begin // subtraction
                temp = a - b;
                if(temp > 4'b0111 || temp < -4'b1000) begin
                    overflow <= 1'b1;
                end else begin
                    overflow <= 1'b0;
                end
                result <= temp[3:0];
            end
            default: begin // default case
                result <= 4'b0;
                overflow <= 1'b0;
            end
        endcase
    end
end

endmodule