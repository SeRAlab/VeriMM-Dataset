module top_module(
    input clk,
    input reset,
    input [7:0] num,
    input a,
    output reg pulse,
    output reg [7:0] count,
    output reg rise,
    output reg down
);reg [7:0] prev_num;
reg [7:0] threshold = 8'h7F; // set threshold value to 127

// Edge detection module
reg prev_a;
always @(posedge clk) begin
    if (reset) begin
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        if (a && !prev_a) begin
            rise <= 1;
        end else begin
            rise <= 0;
        end
        if (!a && prev_a) begin
            down <= 1;
        end else begin
            down <= 0;
        end
        prev_a <= a;
    end
end

// Threshold crossing counter module
reg [1:0] state = 2'b00;
reg [7:0] crossing_count = 0;
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        crossing_count <= 0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (num < threshold) begin
                    pulse <= 1;
                    state <= 2'b01;
                end else begin
                    pulse <= 0;
                    state <= 2'b00;
                end
            end
            2'b01: begin // pulse state
                if (num < threshold) begin
                    pulse <= 0;
                    state <= 2'b10;
                end else begin
                    pulse <= 1;
                    state <= 2'b01;
                end
            end
            2'b10: begin // counting state
                if (num < threshold) begin
                    pulse <= 0;
                    crossing_count <= crossing_count + 1;
                    state <= 2'b10;
                end else begin
                    pulse <= 0;
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule