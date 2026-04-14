module interrupt_controller (  
    input [3:0] IRQ,  
    input ACK,  
    output reg [3:0] IV  
);  

    always @(posedge ACK or posedge IRQ[3] or posedge IRQ[2] or posedge IRQ[1] or posedge IRQ[0]) begin  
        if (ACK) begin  
            IV <= 4'b0000; // Reset IV on acknowledge  
        end else begin  
            if (IRQ[3])  
                IV <= 4'b1000; // Highest priority  
            else if (IRQ[2])  
                IV <= 4'b0100;  
            else if (IRQ[1])  
                IV <= 4'b0010;  
            else if (IRQ[0])  
                IV <= 4'b0001;  
            else  
                IV <= 4'b0000; // No interrupt  
        end  
    end  
endmodule