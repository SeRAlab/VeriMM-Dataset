module top_module(
    input CLK,
    input UP,
    input DOWN,
    input LOAD,
    input [3:0] in,
    input [1:0] shift_amt,
    output reg [6:0] seg_display
);reg [3:0] counter_out;
reg [3:0] shifted_out;
reg [3:0] sum_out;

// Up/Down Counter
always @(posedge CLK) begin
    if (LOAD) begin
        counter_out <= in;
    end else if (UP) begin
        if (counter_out == 4'b1111) begin
            counter_out <= 4'b0000;
        end else begin
            counter_out <= counter_out + 1;
        end
    end else if (DOWN) begin
        if (counter_out == 4'b0000) begin
            counter_out <= 4'b1111;
        end else begin
            counter_out <= counter_out - 1;
        end
    end
end

// Barrel Shifter
always @(posedge CLK) begin
    case (shift_amt)
        2'b00: shifted_out <= counter_out;
        2'b01: shifted_out <= {counter_out[2:0], counter_out[3]};
        2'b10: shifted_out <= {counter_out[1:0], counter_out[3:2]};
        2'b11: shifted_out <= {counter_out[0], counter_out[3:1]};
    endcase
end

// Adder
always @(posedge CLK) begin
    sum_out <= shifted_out + in;
end

// 7-Segment Display Decoder
always @(sum_out) begin
    case (sum_out)
        4'b0000: seg_display <= 7'b1000000; // 0
        4'b0001: seg_display <= 7'b1111001; // 1
        4'b0010: seg_display <= 7'b0100100; // 2
        4'b0011: seg_display <= 7'b0110000; // 3
        4'b0100: seg_display <= 7'b0011001; // 4
        4'b0101: seg_display <= 7'b0010010; // 5
        4'b0110: seg_display <= 7'b0000010; // 6
        4'b0111: seg_display <= 7'b1111000; // 7
        4'b1000: seg_display <= 7'b0000000; // 8
        4'b1001: seg_display <= 7'b0011000; // 9
        4'b1010: seg_display <= 7'b0001000; // A
        4'b1011: seg_display <= 7'b0000011; // B
        4'b1100: seg_display <= 7'b1000110; // C
        4'b1101: seg_display <= 7'b0100001; // D
        4'b1110: seg_display <= 7'b0000110; // E
        4'b1111: seg_display <= 7'b0001110; // F
    endcase
end

endmodule