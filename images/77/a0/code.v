module top_module(
    input clk,
    input reset,
    input [1:0] btn,
    input [9:0] pixel_x,
    input [9:0] ball_x_in, // renamed input to avoid conflict
    input [9:0] ball_y_in, // renamed input to avoid conflict
    output reg [9:0] paddle_x,
    output reg [9:0] ball_x, // added to store ball position
    output reg [9:0] ball_y, // added to store ball position
    output reg game_over
);// Paddle constants
localparam PADDLE_WIDTH = 80;
localparam PADDLE_SPEED = 2;
localparam PADDLE_START_POS = (640 - PADDLE_WIDTH) / 2;

// Ball constants
localparam BALL_SIZE = 10;
localparam BALL_SPEED = 1;

// Game variables
reg [1:0] lives = 2'b11;
reg [9:0] ball_dx = BALL_SPEED;
reg [9:0] ball_dy = BALL_SPEED;

// Initialize paddle and ball position
always @(posedge clk or posedge reset) begin
    if (reset) begin
        paddle_x <= PADDLE_START_POS;
        ball_x <= 0; // Initialize ball_x at reset
        ball_y <= 0; // Initialize ball_y at reset
        game_over <= 0; // Initialize game_over at reset
    end else begin
        paddle_x <= paddle_x; // Preserve paddle_x
    end
end

// Move paddle based on button input
always @(posedge clk) begin
    if (btn == 2'b11 && paddle_x < 640 - PADDLE_WIDTH - PADDLE_SPEED) begin
        paddle_x <= paddle_x + PADDLE_SPEED;
    end else if (btn != 2'b11 && paddle_x > PADDLE_SPEED - 1) begin
        paddle_x <= paddle_x - PADDLE_SPEED;
    end
end

// Detect ball collision with paddle or bottom of screen
always @(posedge clk) begin
    if (ball_y + BALL_SIZE >= 480) begin
        lives <= lives - 1;
        if (lives == 0) begin
            game_over <= 1;
        end else begin
            ball_dy <= -BALL_SPEED;
            ball_dx <= BALL_SPEED;
        end
    end else if (ball_y <= 0) begin
        ball_dy <= BALL_SPEED;
    end else if (ball_x + BALL_SIZE >= paddle_x && ball_x <= paddle_x + PADDLE_WIDTH && ball_y + BALL_SIZE >= 470 && ball_y + BALL_SIZE <= 480) begin
        ball_dy <= -BALL_SPEED;
        ball_dx <= BALL_SPEED;
    end
end

// Update ball position
always @(posedge clk) begin
    if (ball_x + BALL_SIZE >= 640) begin
        ball_dx <= -BALL_SPEED;
    end else if (ball_x <= 0) begin
        ball_dx <= BALL_SPEED;
    end
    ball_x <= ball_x + ball_dx;
    ball_y <= ball_y + ball_dy;
end

endmodule