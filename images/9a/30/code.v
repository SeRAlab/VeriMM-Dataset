module top_module(clk, reset, DAT_I, STB, DAT_O, ACK, WE, Segment, AN, debug_data_hold);input clk, reset;
    input [31: 0] DAT_I;
    input STB;
    input WE;
    output reg [3: 0] AN;
    output [7: 0] Segment;
    output [31: 0] DAT_O;
    output ACK;
    output [15: 0] debug_data_hold;

    reg [7: 0] digit_seg, digit;
    reg [15: 0] data_hold = 16'h2333;
    reg [31: 0] cnt = 0;

    wire [1: 0] scan;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    assign scan = cnt[18: 17];

    
    assign ACK = STB;

    assign Segment = digit_seg;
    assign DAT_O = Segment;

    always @(posedge clk or posedge reset) begin
        if (reset) data_hold <= 16'h2333;
        else data_hold <= STB ? DAT_I : data_hold;
    end

    always @* begin
        case(scan)
            0: AN = 4'b1110;
            1: AN = 4'b1101;
            2: AN = 4'b1011;
            3: AN = 4'b0111;
        endcase
    end

    always @* begin
        case(scan)
            0: digit = data_hold[3: 0];
            1: digit = data_hold[7: 4];
            2: digit = data_hold[11: 8];
            3: digit = data_hold[15: 12];
        endcase
    end

    always @* begin
        case(digit)
            4'b0000: digit_seg = 8'b11000000;
            4'b0001: digit_seg = 8'b11111001;
            4'b0010: digit_seg = 8'b10100100;
            4'b0011: digit_seg = 8'b10110000;
            4'b0100: digit_seg = 8'b10011001;
            4'b0101: digit_seg = 8'b10010010;
            4'b0110: digit_seg = 8'b10000010;
            4'b0111: digit_seg = 8'b11111000;
            4'b1000: digit_seg = 8'b10000000;
            4'b1001: digit_seg = 8'b10010000;
            4'b1010: digit_seg = 8'b10001000;
            4'b1011: digit_seg = 8'b10000011;
            4'b1100: digit_seg = 8'b11000110;
            4'b1101: digit_seg = 8'b10100001;
            4'b1110: digit_seg = 8'b10000110;
            4'b1111: digit_seg = 8'b10001110;
        endcase
    end

    
    assign debug_data_hold = data_hold;

endmodule