module top_module(
    input clk,
    input rst,
    input start,
    output reg green,
    output reg yellow,
    output reg red
);parameter GREEN_TIME = 5;
parameter YELLOW_TIME = 2;
parameter RED_TIME = 3;

reg [2:0] state;
reg [3:0] counter;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        state <= 3'b000;
        counter <= 4'b0000;
        green <= 1'b0;
        yellow <= 1'b0;
        red <= 1'b0;
    end else if (start) begin
        case(state)
            3'b000: begin // Green state
                if (counter == GREEN_TIME) begin
                    state <= 3'b001;
                    counter <= 4'b0000;
                    green <= 1'b0;
                    yellow <= 1'b1;
                    red <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    green <= 1'b1;
                    yellow <= 1'b0;
                    red <= 1'b0;
                end
            end
            3'b001: begin // Yellow state
                if (counter == YELLOW_TIME) begin
                    state <= 3'b010;
                    counter <= 4'b0000;
                    green <= 1'b0;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end else begin
                    counter <= counter + 1;
                    green <= 1'b0;
                    yellow <= 1'b1;
                    red <= 1'b0;
                end
            end
            3'b010: begin // Red state
                if (counter == RED_TIME) begin
                    state <= 3'b000;
                    counter <= 4'b0000;
                    green <= 1'b1;
                    yellow <= 1'b0;
                    red <= 1'b0;
                end else begin
                    counter <= counter + 1;
                    green <= 1'b0;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end
            end
        endcase
    end
end

endmodule