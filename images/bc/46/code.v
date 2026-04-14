module top_module(
    input clk,
    input reset,
    output reg [6:0] seg,
    output reg [3:0] an
);reg [3:0] hours = 4'd0;
reg [3:0] minutes = 4'd0;
reg [3:0] seconds = 4'd0;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0;
        minutes <= 4'd0;
        seconds <= 4'd0;
    end else begin
        seconds <= seconds + 1;
        if (seconds == 60) begin
            seconds <= 4'd0;
            minutes <= minutes + 1;
        end
        if (minutes == 60) begin
            minutes <= 4'd0;
            hours <= hours + 1;
        end
        if (hours == 24) begin
            hours <= 4'd0;
        end
    end
end

always @(hours, minutes, seconds) begin
    case ({hours, minutes, seconds})
        0: begin seg = 7'b1111110; an = 4'b1110; end // 0
        1: begin seg = 7'b0110000; an = 4'b1110; end // 1
        2: begin seg = 7'b1101101; an = 4'b1110; end // 2
        3: begin seg = 7'b1111001; an = 4'b1110; end // 3
        4: begin seg = 7'b0110011; an = 4'b1110; end // 4
        5: begin seg = 7'b1011011; an = 4'b1110; end // 5
        6: begin seg = 7'b1011111; an = 4'b1110; end // 6
        7: begin seg = 7'b1110000; an = 4'b1110; end // 7
        8: begin seg = 7'b1111111; an = 4'b1110; end // 8
        9: begin seg = 7'b1111011; an = 4'b1110; end // 9
        default: begin seg = 7'b0000000; an = 4'b1111; end // blank
    endcase
end

endmodule