module pulse_generator #(parameter PULSE_WIDTH = 5)  
(  
    input wire clk,  
    input wire trigger,  
    output reg pulse  
);  
    reg [3:0] count;  
    reg generating;  
    
    always @(posedge clk) begin  
        if (trigger) begin  
            generating <= 1;  
            count <= 0;  
        end else if (generating) begin  
            if (count < PULSE_WIDTH - 1) begin  
                count <= count + 1;  
            end else begin  
                pulse <= 0;  
                generating <= 0;  
            end  
        end  
    end  
   
    always @(posedge clk) begin  
        if (generating) begin  
            pulse <= 1;  
        end else begin  
            pulse <= 0;  
        end  
    end  
endmodule