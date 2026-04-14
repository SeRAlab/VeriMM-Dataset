module interrupt_controller(  
    input [3:0] irq,  
    input enable,  
    output reg [3:0] ack  
);  
    always @(*) begin  
        if (enable) begin  
            ack = 4'b0000;  
            if (irq[3]) ack = 4'b1000;  
            else if (irq[2]) ack = 4'b0100;  
            else if (irq[1]) ack = 4'b0010;  
            else if (irq[0]) ack = 4'b0001;  
        end  
        else begin  
            ack = 4'b0000;  
        end  
    end  
endmodule