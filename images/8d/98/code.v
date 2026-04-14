module top_module(
    input clk,
    input rst,
    input enable,
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);reg [3:0] state;
reg [25:0] counter;

parameter GREEN_TIME = 500_000_000; // 10 seconds at 50MHz
parameter YELLOW_TIME = 100_000_000; // 2 seconds at 50MHz
parameter RED_TIME = 400_000_000; // 8 seconds at 50MHz

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b001;
        counter <= 0;
    end else if (enable) begin
        case (state)
            4'b001: begin // Green light
                green_light <= 1;
                if (counter == GREEN_TIME - 1) begin
                    state <= 4'b010;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            4'b010: begin // Yellow light
                green_light <= 0;
                yellow_light <= 1;
                if (counter == YELLOW_TIME - 1) begin
                    state <= 4'b100;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            4'b100: begin // Red light
                yellow_light <= 0;
                red_light <= 1;
                if (counter == RED_TIME - 1) begin
                    state <= 4'b001;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end else begin // System is disabled
        state <= 4'b001;
        counter <= 0;
        green_light <= 0;
        yellow_light <= 0;
        red_light <= 0;
    end
end

endmodule