module top_module(
    input reset,
    input advance,
    input [9:0] ball_y,
    output reg [9:0] paddle_y
);parameter PADDLESIZE = 10;
    parameter SCREENHEIGHT = 480;
    parameter INCREMENT = 1;

    reg paddleDir;
    reg [9:0] ptop;
    reg [9:0] pbot;

    function [9:0] paddlelimiter;
        input [9:0] py;
        begin
            if (py < PADDLESIZE/2) 
                paddlelimiter = PADDLESIZE/2;
            else if (py > SCREENHEIGHT-PADDLESIZE/2)
                paddlelimiter = SCREENHEIGHT-PADDLESIZE/2;
            else
                paddlelimiter = py;
        end
    endfunction

    always @(negedge advance or posedge reset) begin
        if (reset) begin
            paddle_y <= SCREENHEIGHT/2;
        end
        else begin
            if (ball_y < ptop || ball_y > pbot) begin
                if (paddleDir == 1'b0)
                    paddle_y <= paddlelimiter(paddle_y + INCREMENT);
                else
                    paddle_y <= paddlelimiter(paddle_y - INCREMENT);
            end
        end
    end

    always @(posedge advance) begin
        ptop <= paddle_y - PADDLESIZE/2;
        pbot <= paddle_y + PADDLESIZE/2;
        paddleDir <= ball_y < paddle_y;
    end

endmodule