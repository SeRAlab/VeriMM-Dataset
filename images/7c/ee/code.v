module top_module(
    input CLOCK,
    input RESET,
    input [2:0] MODE,
    input FAST,
    output reg [7:0] LED
);reg [7:0] brightness;
reg [6:0] counter;

always @(posedge CLOCK) begin
    if (RESET) begin
        brightness <= 0;
        counter <= 0;
    end else begin
        if (FAST) begin
            if (counter == 9) begin
                counter <= 0;
                case (MODE)
                    3'b000: brightness <= 0;
                    3'b001: brightness <= 4'b1000;
                    3'b010: brightness <= 4'b1100;
                    3'b011: brightness <= 4'b1111;
                    default: brightness <= 0;
                endcase
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 99) begin
                counter <= 0;
                case (MODE)
                    3'b000: brightness <= 0;
                    3'b001: brightness <= 4'b1000;
                    3'b010: brightness <= 4'b1100;
                    3'b011: brightness <= 4'b1111;
                    default: brightness <= 0;
                endcase
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

assign LED = brightness;

endmodule