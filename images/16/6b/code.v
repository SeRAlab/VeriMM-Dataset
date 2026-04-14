module qam_modulator (
    input [3:0] symbol,
    output reg [7:0] I,
    output reg [7:0] Q
);
    
    always @(symbol) begin
        case (symbol)
            4'b0000: begin I = 8'd0;  Q = 8'd0; end
            4'b0001: begin I = 8'd0;  Q = 8'd10; end
            4'b0010: begin I = 8'd10; Q = 8'd0; end
            4'b0011: begin I = 8'd10; Q = 8'd10; end
            4'b0100: begin I = 8'd20; Q = 8'd0; end
            4'b0101: begin I = 8'd20; Q = 8'd10; end
            4'b0110: begin I = 8'd30; Q = 8'd0; end
            4'b0111: begin I = 8'd30; Q = 8'd10; end
            4'b1000: begin I = 8'd0;  Q = 8'd20; end
            4'b1001: begin I = 8'd0;  Q = 8'd30; end
            4'b1010: begin I = 8'd10; Q = 8'd20; end
            4'b1011: begin I = 8'd10; Q = 8'd30; end
            4'b1100: begin I = 8'd20; Q = 8'd20; end
            4'b1101: begin I = 8'd20; Q = 8'd30; end
            4'b1110: begin I = 8'd30; Q = 8'd20; end
            4'b1111: begin I = 8'd30; Q = 8'd30; end
            default: begin I = 8'd0; Q = 8'd0; end
        endcase
    end
endmodule