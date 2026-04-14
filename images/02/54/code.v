module interrupt_controller (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] IRQ,  
    input wire GIE,  
    output reg INT  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            INT <= 0;  
        end else begin  
            if (GIE) begin  
                case (IRQ)  
                    4'b0001: INT <= 1; // IRQ0  
                    4'b0010: INT <= 1; // IRQ1  
                    4'b0100: INT <= 1; // IRQ2  
                    4'b1000: INT <= 1; // IRQ3  
                    default: INT <= 0; // No IRQ  
                endcase  
            end else begin  
                INT <= 0;  
            end  
        end  
    end  
endmodule