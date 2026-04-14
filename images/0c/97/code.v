module qam_modulator (
    input clk,
    input reset,
    input [3:0] symbol,
    output reg signed [3:0] I,
    output reg signed [3:0] Q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            I <= 4'b0000;
            Q <= 4'b0000;
        end else begin
            case (symbol)
                4'b0000: begin I <= 4'd1;  Q <= 4'd1; end
                4'b0001: begin I <= 4'd1;  Q <= 4'd3; end
                4'b0010: begin I <= 4'd3;  Q <= 4'd1; end
                4'b0011: begin I <= 4'd3;  Q <= 4'd3; end
                4'b0100: begin I <= 4'd1;  Q <= -4'd1; end
                4'b0101: begin I <= 4'd1;  Q <= -4'd3; end
                4'b0110: begin I <= 4'd3;  Q <= -4'd1; end
                4'b0111: begin I <= 4'd3;  Q <= -4'd3; end
                4'b1000: begin I <= -4'd1; Q <= 4'd1; end
                4'b1001: begin I <= -4'd1; Q <= 4'd3; end
                4'b1010: begin I <= -4'd3; Q <= 4'd1; end
                4'b1011: begin I <= -4'd3; Q <= 4'd3; end
                4'b1100: begin I <= -4'd1; Q <= -4'd1; end
                4'b1101: begin I <= -4'd1; Q <= -4'd3; end
                4'b1110: begin I <= -4'd3; Q <= -4'd1; end
                4'b1111: begin I <= -4'd3; Q <= -4'd3; end
                default: begin I <= 4'b0000; Q <= 4'b0000; end
            endcase
        end
    end

endmodule