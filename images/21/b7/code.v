module qam_modulator (
    input [3:0] symbol,
    input clk,
    input rst,
    output reg signed [3:0] I,
    output reg signed [3:0] Q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        I <= 0;
        Q <= 0;
    end else begin
        case (symbol)
            4'b0000: begin I <= 0; Q <= 0; end
            4'b0001: begin I <= 0; Q <= 1; end
            4'b0010: begin I <= 1; Q <= 0; end
            4'b0011: begin I <= 1; Q <= 1; end
            4'b0100: begin I <= 0; Q <= -1; end
            4'b0101: begin I <= 0; Q <= -2; end
            4'b0110: begin I <= 2; Q <= 0; end
            4'b0111: begin I <= 2; Q <= 1; end
            // additional cases would be defined here
            default: begin I <= 0; Q <= 0; end
        endcase
    end
end
endmodule