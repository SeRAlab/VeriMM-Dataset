module top_module(
    input clk,
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] prev_in;
reg rising_edge, falling_edge;

always @(posedge clk) begin
    prev_in <= in;
    rising_edge <= 0;
    falling_edge <= 0;
    if (in[0] != prev_in[0]) begin
        if (in[0] == 1)
            rising_edge <= 1;
        else
            falling_edge <= 1;
    end
end

always @* begin
    pos = 0;
    if (rising_edge) begin
        casez(in)
            1'b1: pos = 1;
            2'b01: pos = 2;
            3'b001: pos = 3;
            4'b0001: pos = 4;
            5'b00001: pos = 5;
            6'b000001: pos = 6;
            7'b0000001: pos = 7;
            8'b00000001: pos = 8;
        endcase
    end else if (falling_edge) begin
        casez(prev_in)
            1'b0: pos = 1;
            2'b10: pos = 2;
            3'b110: pos = 3;
            4'b1110: pos = 4;
            5'b11110: pos = 5;
            6'b111110: pos = 6;
            7'b1111110: pos = 7;
            8'b11111110: pos = 8;
        endcase
    end
end

endmodule