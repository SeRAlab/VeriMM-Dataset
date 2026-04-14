module pulse_generator(  
    input wire clk,  
    input wire rst,  
    input wire trigger,  
    input wire [3:0] duration,  
    output reg pulse  
);  
    reg [3:0] count;  
    reg active;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pulse <= 0;  
            count <= 0;  
            active <= 0;  
        end else if (trigger && !active) begin  
            pulse <= 1;  
            count <= duration;  
            active <= 1;  
        end else if (active) begin  
            if (count > 0) begin  
                count <= count - 1;  
            end else begin  
                pulse <= 0;  
                active <= 0;  
            end  
        end  
    end  
endmodule