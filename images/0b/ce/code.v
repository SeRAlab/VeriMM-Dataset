module slam_fsm (  
    input clk,  
    input rst,  
    input up,  
    input down,  
    input left,  
    input right,  
    input [4:0] x_in,  
    input [4:0] y_in,  
    output reg [4:0] x_out,  
    output reg [4:0] y_out  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  

    localparam IDLE = 2'b00, MOVE = 2'b01;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            x_out <= 5'b00000;  
            y_out <= 5'b00000;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (up || down || left || right)  
                    next_state = MOVE;  
                else  
                    next_state = IDLE;  
            end  
            MOVE: begin  
                if (up) begin  
                    if (y_in < 5'b11111)  
                        y_out = y_in + 1;  
                    else  
                        y_out = y_in;  
                end else if (down) begin  
                    if (y_in > 5'b00000)  
                        y_out = y_in - 1;  
                    else  
                        y_out = y_in;  
                end else if (left) begin  
                    if (x_in > 5'b00000)  
                        x_out = x_in - 1;  
                    else  
                        x_out = x_in;  
                end else if (right) begin  
                    if (x_in < 5'b11111)  
                        x_out = x_in + 1;  
                    else  
                        x_out = x_in;  
                end  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule