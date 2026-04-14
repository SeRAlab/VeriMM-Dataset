module interrupt_controller(  
    input clk,  
    input rst,  
    input ext_interrupt,  
    input timer_interrupt,  
    input enable_ext,  
    input enable_timer,  
    output reg [1:0] current_interrupt, // 00: none, 01: ext, 10: timer  
    output reg ack  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_interrupt <= 2'b00;  
            ack <= 0;  
        end else begin  
            if (enable_ext && ext_interrupt) begin  
                current_interrupt <= 2'b01; // service external interrupt  
                ack <= 1;  
            end else if (enable_timer && timer_interrupt) begin  
                current_interrupt <= 2'b10; // service timer interrupt  
                ack <= 1;  
            end else begin  
                ack <= 0;  
            end  
        end  
    end  
endmodule