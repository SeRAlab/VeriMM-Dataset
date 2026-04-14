module top_module(
    CLOCK, 
    RESET,
    A, 
    B, 
    COUNT_ENABLE,
    DIRECTION, 
    SPEED
);input CLOCK, RESET, A, B;
    output COUNT_ENABLE;
    output DIRECTION;
    output reg [3:0] SPEED; // Changed to reg

    reg [2:0] A_delayed;
    reg [2:0] B_delayed;
    reg [31:0] total;
    
    always @(posedge CLOCK or posedge RESET) begin 
        if (RESET) begin 
            A_delayed <= 0;
            B_delayed <= 0;
            total <= 0;
        end else begin
            A_delayed <= {A_delayed[1:0], A};
            B_delayed <= {B_delayed[1:0], B};
        end
    end
    
    wire count_enable = A_delayed[1] ^ A_delayed[2] ^ B_delayed[1] ^ B_delayed[2];
    wire count_direction = A_delayed[1] ^ B_delayed[2];
    
    always @(posedge CLOCK or posedge RESET) begin
        if (RESET) begin 
            total <= 0;
        end 
        else if (count_enable) begin
            // only want a final count between 0 & 27 (x4 for the clicks)
            if (count_direction && total < 109) begin 
                total <= total + 1; 
            end
            else if (!count_direction && total > 0) begin 
                total <= total - 1;
            end
        end
    end
    
    assign COUNT_ENABLE = count_enable;
    assign DIRECTION =  count_direction;
    
    always @(*) begin
        if (total <= 27) begin
            SPEED = 4'b0001;
        end
        else if (total <= 54) begin
            SPEED = 4'b0010;
        end
        else if (total <= 81) begin
            SPEED = 4'b0100;
        end
        else begin
            SPEED = 4'b1000;
        end
    end

endmodule