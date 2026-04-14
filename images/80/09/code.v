module stopwatch (
    input clk,
    input start,
    input stop,
    input reset,
    output reg [6:0] seg0,
    output reg [6:0] seg1);reg [6:0] count_units, count_tens;
    reg running;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_units <= 0;
            count_tens <= 0;
            running <= 0;
        end else if (start) begin
            running <= 1;
        end else if (stop) begin
            running <= 0;
        end else if (running) begin
            if (count_units == 9) begin
                count_units <= 0;
                if (count_tens == 9) begin
                    count_tens <= 0;
                end else begin
                    count_tens <= count_tens + 1;
                end
            end else begin
                count_units <= count_units + 1;
            end
        end
    end

    always @(*) begin
        case (count_units)
            0: seg0 = 7'b1000000;
            1: seg0 = 7'b1111001;
            2: seg0 = 7'b0100100;
            3: seg0 = 7'b0110000;
            4: seg0 = 7'b0011001;
            5: seg0 = 7'b0010010;
            6: seg0 = 7'b0000010;
            7: seg0 = 7'b1111000;
            8: seg0 = 7'b0000000;
            9: seg0 = 7'b0010000;
            default: seg0 = 7'b1111111;
        endcase

        case (count_tens)
            0: seg1 = 7'b1000000;
            1: seg1 = 7'b1111001;
            2: seg1 = 7'b0100100;
            3: seg1 = 7'b0110000;
            4: seg1 = 7'b0011001;
            5: seg1 = 7'b0010010;
            6: seg1 = 7'b0000010;
            7: seg1 = 7'b1111000;
            8: seg1 = 7'b0000000;
            9: seg1 = 7'b0010000;
            default: seg1 = 7'b1111111;
        endcase
    end

endmodule