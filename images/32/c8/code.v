module PLL_8x (  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out  
);  

    reg [2:0] state;  
    reg [2:0] next_state;  

    localparam IDLE = 3'b000,  
               LOCKED = 3'b001,  
               DIVIDE = 3'b010;  

    always @(posedge clk_in or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: next_state = LOCKED;  
            LOCKED: next_state = DIVIDE;  
            DIVIDE: next_state = LOCKED;  
            default: next_state = IDLE;  
        endcase  
    end  

    always @(posedge clk_in) begin  
        if (state == DIVIDE) begin  
            clk_out <= ~clk_out;  
        end  
    end  

endmodule