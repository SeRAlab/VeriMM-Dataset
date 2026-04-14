module top_module(
    input clk,
    input [6:0] DISPLAY1,
    input [6:0] DISPLAY2,
    input [6:0] DISPLAY3,
    input [6:0] DISPLAY4,
    output reg [6:0] DISPLAY,
    output reg [3:0] ANODES
);reg [1:0] state, next_state;
    parameter IDLE = 2'b00, ONE = 2'b01, P = 2'b10, AC = 2'b11;
    reg [3:0] counter;

    always @ (posedge clk) begin
        if (counter == 250) begin
            state <= next_state;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always @ (state) begin
        case (state)
            IDLE: next_state = ONE;
            ONE: next_state = P;
            P: next_state = AC;
            AC: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @ (*) begin
        case (state)
            IDLE: begin
                DISPLAY <= 7'b1111110;
                ANODES <= 4'b0001;
            end
            ONE: begin
                DISPLAY <= DISPLAY1;
                ANODES <= 4'b1110;
            end
            P: begin
                DISPLAY <= DISPLAY2;
                ANODES <= 4'b1101;
            end
            AC: begin
                DISPLAY <= DISPLAY3;
                ANODES <= 4'b1011;
            end
            default: begin
                DISPLAY <= 7'b1111110;
                ANODES <= 4'b0001;
            end
        endcase
    end

endmodule