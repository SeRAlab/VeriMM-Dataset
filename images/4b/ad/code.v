module top_module(
    input [7:0] in,
    output reg [3:0] OUT0,
    output reg [3:0] OUT1,
    output reg [3:0] OUT2
);always @(*) begin
    casez(in)
        8'b00000001: begin
            OUT0 = 0;
            OUT1 = 0;
            OUT2 = 0;
        end
        8'b00000010: begin
            OUT0 = 1;
            OUT1 = 0;
            OUT2 = 0;
        end
        8'b00000100: begin
            OUT0 = 2;
            OUT1 = 0;
            OUT2 = 0;
        end
        8'b00001000: begin
            OUT0 = 3;
            OUT1 = 0;
            OUT2 = 0;
        end
        8'b00010000: begin
            OUT0 = 0;
            OUT1 = 1;
            OUT2 = 0;
        end
        8'b00100000: begin
            OUT0 = 1;
            OUT1 = 1;
            OUT2 = 0;
        end
        8'b01000000: begin
            OUT0 = 2;
            OUT1 = 1;
            OUT2 = 0;
        end
        8'b10000000: begin
            OUT0 = 3;
            OUT1 = 1;
            OUT2 = 0;
        end
        default: begin
            OUT0 = 0;
            OUT1 = 0;
            OUT2 = 1;
        end
    endcase
end

endmodule