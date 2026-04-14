module top_module(
    input  [15:0] x,
    input  clk,
    input  clr,
    output reg [6:0] a_to_g,
    output reg [3:0] an,
    output wire dp
);wire [1:0] s;
    reg  [3:0] digit;
    wire [3:0] aen;
    reg  [19:0] clkdiv;
    
    assign dp = 1;
    assign s[0] = clkdiv[18]; // count every 5.2 ms
    assign s[1] = clkdiv[17];
    assign aen = 4'b1111; // enable all digits
    
    always @ ( * ) begin
        case (s)
            2'b00: digit = x[3:0];
            2'b01: digit = x[7:4];
            2'b10: digit = x[11:8];
            2'b11: digit = x[15:12];
            default: digit = 4'b0000;
        endcase
    end

    // 7-segment display
    always @ ( * ) begin
        case (digit)
            4'b0000: a_to_g = 7'b1111110;
            4'b0001: a_to_g = 7'b0110000;
            4'b0010: a_to_g = 7'b1101101;
            4'b0011: a_to_g = 7'b1111001;
            4'b0100: a_to_g = 7'b0110011;
            4'b0101: a_to_g = 7'b1011011;
            4'b0110: a_to_g = 7'b1011111;
            4'b0111: a_to_g = 7'b1110000;
            4'b1000: a_to_g = 7'b1111111;
            4'b1001: a_to_g = 7'b1110011;
            default: a_to_g = 7'b1111110; // 0
        endcase
    end

    // Digit select: ancode
    always @ ( * ) begin
        an = 4'b1111;
        if (aen[s] == 1) begin
            an[s] = 0;
        end
    end

    // Clock divider
    always @ (posedge clk or posedge clr) begin
        if (clr == 1) begin
            clkdiv <= 0;
        end
        else begin
            clkdiv <= clkdiv + 1;
        end
    end

endmodule