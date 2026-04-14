module deadbeat_controller (  
    input clk,  
    input reset,  
    input [3:0] u,  
    output reg [3:0] y  
);  
    reg [1:0] state;  
    reg [3:0] desired_value;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 0;  
            state <= 0;  
            desired_value <= 4'b1111; // Example desired state  
        end  
        else begin  
            case (state)  
                2'b00: begin  
                    y <= u;  
                    state <= 2'b01;  
                end  
                2'b01: begin  
                    y <= desired_value;  
                    state <= 2'b10;  
                end  
                2'b10: begin  
                    // Stay in final state  
                    state <= 2'b10;  
                end  
            endcase  
        end  
    end  
endmodule