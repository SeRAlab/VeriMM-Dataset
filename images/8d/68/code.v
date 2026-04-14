module top_module(
    CLOCK, 
    RESET,
    POSITION,
    BALL_H,
    BALL_V
);input CLOCK, RESET;
    input [10:0] BALL_H;
    input [10:0] BALL_V;
    output [7:0] POSITION;
    
    reg [10:0] paddle;
    
    
    
    always @ (posedge CLOCK or posedge RESET) begin
        if (RESET) begin
            paddle <= 0;
        end else begin
            if (BALL_V < 11'd32) begin
                
                paddle <= 0;
            end else if (BALL_V > 11'd432) begin
                
                paddle <= 11'd400;
            end else begin
                
                paddle <= BALL_V - 11'd32;
            end
        end
    end
    
  
    
    wire [10:0] final_paddle_pos = paddle >> 1; 
    assign POSITION = final_paddle_pos[7:0]; 
    
endmodule